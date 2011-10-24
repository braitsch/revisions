package model.proxies.remote.repo {

	import model.remote.HostingAccount;
	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.remote.RemoteFailure;
	import model.proxies.remote.RemoteProxy;
	import model.remote.Hosts;
	import model.vo.Repository;

	public class RepairProxy extends RemoteProxy {

		private var _request	:GitRequest;
		private var _acctName	:String;
		private var _repoName	:String;
		private var _userName	:String;
		private var _userPass	:String;
		private var _saveAcct	:Boolean;

		public function RepairProxy()
		{
			super.executable = 'BkmkRemote.sh';
		}
		
		public function set request(req:GitRequest):void
		{
			_request = req; inspectRequest();
		}
		
		private function inspectRequest():void
		{
			_acctName = Repository.getAccountName(_request.url);
			_repoName = _request.url.substr(_request.url.lastIndexOf('/') + 1);
			if (_request.type == HostingAccount.BEANSTALK){
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
			if (_request.type == HostingAccount.GITHUB && !Hosts.github.loggedIn){
				m = 'Please login to your GitHub account so I can complete your request.';
			}	else if (_request.type == HostingAccount.BEANSTALK && !Hosts.beanstalk.loggedIn){
				m = 'Please login to your Beanstalk account so I can complete your request.';
			}	else{
				m = 'I\'m sorry, '+_request.type+' denied us access to the account you are trying to connect to. ';
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
				if (_request.type == HostingAccount.GITHUB){
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
			_request.url = 'https://' + _userName + ':' + _userPass + '@github.com/' + _acctName + '/' + _repoName;
			trace("RepairProxy.attemptHttpsRequest()", _request.url);
			super.call(Vector.<String>([_request.method, _request.url, _request.args]));
		}		

		private function addKeyToBeanstalkAcct():void
		{
			Hosts.beanstalk.addKeyToAccount(makeAcctObj(), _saveAcct);
			Hosts.beanstalk.key.addEventListener(AppEvent.REMOTE_KEY_READY, onKeyAddedToBeanstalk);
		}
		
		private function onKeyAddedToBeanstalk(e:AppEvent):void
		{
		// retry the failed beanstalk request //
			super.call(Vector.<String>([_request.method, _request.url, _request.args]));
			Hosts.beanstalk.key.removeEventListener(AppEvent.REMOTE_KEY_READY, onKeyAddedToBeanstalk);
		}
		
		private function makeAcctObj():HostingAccount
		{
			return new HostingAccount({type:_request.type, acct:_acctName, user:_userName, pass:_userPass});		
		}						
		
	// handle responses //	
		
		override protected function onProcessComplete(e:NativeProcessEvent):void
		{
			trace("RepairProxy.onProcessComplete(e)", e.data.method, e.data.result);
			super.onProcessComplete(e);
			var f:String = RemoteFailure.detectFailure(e.data.result);
			if (f){
			//	onProcessFailure(f);
			}	else{
				// rewrite remote url on the repository....!!!
				dispatchEvent(new AppEvent(AppEvent.REMOTE_REPAIRED, {method:e.data.method, result:e.data.result}));
				if (_saveAcct && _request.type == HostingAccount.GITHUB) Hosts.github.writeAcctToDatabase(makeAcctObj());
			}
		}
		
	}
	
}
