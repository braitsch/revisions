package model.proxies.remote.repo {

	import events.AppEvent;
	import events.ErrEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.remote.RemoteFailure;
	import model.proxies.remote.RemoteProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import system.BashMethods;

	public class GitProxy extends RemoteProxy {

		private var _request			:GitRequest;
		private var _acctName			:String;
		private var _repoName			:String;
		private var _acctType			:String;
		private var _userName			:String;
		private var _userPass			:String;
		private var _saveAcct			:Boolean;
		private var _attemptNum			:uint;
		private static var _working		:Boolean;		

		public function GitProxy()
		{
			super.executable = 'BkmkRemote.sh';
		}
		
		protected function get working():Boolean
		{
			return _working;
		}		
		
		public function set request(req:GitRequest):void
		{
			_attemptNum = 1; _request = req; attemptRequest();
		}
		
		private function attemptRequest():void
		{
			_working = true;
			trace("GitProxy.attemptRequest()", _attemptNum, _request.method, _request.remote.url, _request.args);
			super.appendArgs(_request.args);
			if (_request.method == BashMethods.PUSH_BRANCH && _attemptNum == 1){
				super.call(Vector.<String>([_request.method, _request.remote.name]));
			}	else {
				super.call(Vector.<String>([_request.method, _request.remote.url]));
			}
		}
		//	if (_request.remote.url.search(/(https:\/\/)(\w*)(@github.com)/) == -1){
		
		private function retryRequest():void
		{
			_attemptNum++;
			trace('_attemptNum: ' + (_attemptNum));
			if (_attemptNum == 2){
				inspectRequest();
			}	else{
				promptForPassword();
			}
		}
		
		private function inspectRequest():void
		{
			_acctName = _request.remote.acctName;
			_repoName = _request.remote.repoName;
			_acctType = _request.remote.acctType;
			if (_acctType == HostingAccount.BEANSTALK){
				promptForPassword();
			}	else{
				handleGitHubFailure();
			}
		}

		private function handleGitHubFailure():void
		{
			if (Hosts.github.loggedIn == null){
				promptForPassword();
			}	else{
				_userName = Hosts.github.loggedIn.user;
				_userPass = Hosts.github.loggedIn.pass;
				attemptHttpsRequest();
			}
		}
		
		private function promptForPassword():void
		{
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.PERMISSIONS_FAILURE, getPermissionsMessage());
			AppModel.engine.addEventListener(AppEvent.RETRY_REMOTE_REQUEST, onNewCredentials);
		}

		private function getPermissionsMessage():String
		{
			var m:String;
			if (_attemptNum > 2){
				m = 'Invalid username and / or password. Please try again.';
			}	else if (_acctType == HostingAccount.GITHUB && !Hosts.github.loggedIn){
				m = 'Please login to your GitHub account so I can complete your request.';
			}	else if (_acctType == HostingAccount.BEANSTALK && !Hosts.beanstalk.loggedIn){
				m = 'Please login to your Beanstalk account so I can complete your request.';
			}	else{
				m = 'I\'m sorry, '+_acctType +' denied us access to the account you are trying to connect to. ';
				m+= 'Please enter your username & password to try again :';
			}
			return m;
		}

		private function onNewCredentials(e:AppEvent):void
		{
			if (e.data){
				_userName = e.data.user;
				_userPass = e.data.pass;
				_saveAcct = e.data.save;
				if (_acctType == HostingAccount.GITHUB){
					attemptHttpsRequest();
				}	else{
					addKeyToBeanstalkAcct();	
				}
			}	else{
				_working = false; // user hit cancel button on password prompt //
			}
			AppModel.engine.removeEventListener(AppEvent.RETRY_REMOTE_REQUEST, onNewCredentials);
		}

		private function attemptHttpsRequest():void
		{
			_request.remote.url = 'https://' + _userName + ':' + _userPass + '@github.com/' + _acctName + '/' + _repoName +'.git';
			attemptRequest();
		}		

		private function addKeyToBeanstalkAcct():void
		{
			Hosts.beanstalk.addKeyToAccount(makeAcctObj(), _saveAcct);
			Hosts.beanstalk.key.addEventListener(AppEvent.REMOTE_KEY_READY, onKeyAddedToBeanstalk);
		}
		
		private function onKeyAddedToBeanstalk(e:AppEvent):void
		{
		// retry the failed beanstalk request //
			super.appendArgs(_request.args);
			super.call(Vector.<String>([_request.method]));
			Hosts.beanstalk.key.removeEventListener(AppEvent.REMOTE_KEY_READY, onKeyAddedToBeanstalk);
		}
		
		private function makeAcctObj():HostingAccount
		{
			return new HostingAccount({type:_acctType, acct:_acctName, user:_userName, pass:_userPass});		
		}						
		
	// handle responses //	
		
		override protected function onProcessComplete(e:NativeProcessEvent):void
		{
			trace("GitProxy.onProcessComplete(e)", 'm='+e.data.method, 'r='+e.data.result);
			_working = false;
			super.onProcessComplete(e);
			var f:String = RemoteFailure.detectFailure(e.data.result);
			trace("GitProxy.onProcessComplete(e) -- failure = ",f);
			if (f){
				onProcessFailure(f);
			}	else{
				onProcessSuccess(e);
			}
		}

		protected function onProcessSuccess(e:NativeProcessEvent):void
		{
			if (_request.method == BashMethods.PUSH_BRANCH && _attemptNum > 1){
			// update the remote url so future push attempts will succeed //	
				AppModel.proxies.editor.editRemote(_request.remote);
			}
			if (_saveAcct && _acctType == HostingAccount.GITHUB) Hosts.github.writeAcctToDatabase(makeAcctObj());
		}
		
		private function onProcessFailure(f:String):void 
		{
			switch(f){
				case RemoteFailure.AUTHENTICATION	:
					onAuthenticationFailure();
				break;
				case RemoteFailure.USER_FORBIDDEN	:
					dispatchError(ErrEvent.USER_FORBIDDEN);
				break;				
				case RemoteFailure.MALFORMED_URL	:
					dispatchError(ErrEvent.UNRESOLVED_HOST);
				break;
				case RemoteFailure.REPO_NOT_FOUND	:
					dispatchError(ErrEvent.REPO_NOT_FOUND);
				break;
			}
		}
		
		private function onAuthenticationFailure():void 
		{ 
			trace("GitProxy.onAuthenticationFailure()");
			if (hasString(_request.remote.url, 'git://github.com') || hasString(_request.remote.url, 'https://github.com')){
		// a read-only request has failed //	
				dispatchError(ErrEvent.UNRESOLVED_HOST);
			}	else if (hasString(_request.remote.url, 'git@github.com')){
		// user doesn't have an ssh key setup, retry over https //		
				retryRequest();
			}	else{
		// a beanstalk ssh request or a private github https request has failed //
				retryRequest();
			}
		}
		
		private static function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }			
		
	}
	
}
