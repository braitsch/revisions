package model.proxies.remote.repo {

	import events.AppEvent;
	import events.ErrEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.remote.RemoteFailure;
	import model.proxies.remote.RemoteProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;

	public class RepairProxy extends RemoteProxy {

		private var _request	:GitRequest;
		private var _acctName	:String;
		private var _repoName	:String;
		private var _acctType	:String;
		private var _userName	:String;
		private var _userPass	:String;
		private var _saveAcct	:Boolean;
		private var _attemptNum	:uint;

		public function RepairProxy()
		{
			super.executable = 'BkmkRemote.sh';
		}
		
		public function set request(req:GitRequest):void
		{
			_attemptNum = 0; _request = req; inspectRequest();
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
			if (_attemptNum > 0){
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
				dispatchEvent(new AppEvent(AppEvent.REQUEST_CANCELLED));
			}
			AppModel.engine.removeEventListener(AppEvent.RETRY_REMOTE_REQUEST, onNewCredentials);
		}
		
	// actual requests //	

		private function attemptHttpsRequest():void
		{
			_request.remote.url = 'https://' + _userName + ':' + _userPass + '@github.com/' + _acctName + '/' + _repoName +'.git';
//			trace('---------------------------------');
//			trace("RepairProxy.attemptHttpsRequest()", _request.method, _request.remote.url, _request.args);
//			trace('---------------------------------');
			super.appendArgs(_request.args);
		// may need to inspect method here, regular git push may require 'remote-name' instead of url to sync with git cherry.	
			super.call(Vector.<String>([_request.method, _request.remote.url]));
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
			super.onProcessComplete(e);
			var f:String = RemoteFailure.detectFailure(e.data.result);
			if (f){
				onProcessFailure(f);
			}	else{
				// rewrite remote url on the repository....!!!
				dispatchEvent(new AppEvent(AppEvent.REMOTE_REPAIRED, {method:e.data.method, result:e.data.result}));
				if (_saveAcct && _acctType == HostingAccount.GITHUB) Hosts.github.writeAcctToDatabase(makeAcctObj());
			}
		}
		
		private function onProcessFailure(f:String):void 
		{
			switch(f){
				case RemoteFailure.AUTHENTICATION	:
					_attemptNum++; promptForPassword();
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
		
	}
	
}
