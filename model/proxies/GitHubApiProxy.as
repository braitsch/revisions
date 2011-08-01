package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import system.BashMethods;
	import com.adobe.serialization.json.JSONDecoder;

	public class GitHubApiProxy extends NativeProcessProxy {

		private static var _accountData			:Object;
		private static var _connectionErrors	:Array = [	'fatal: unable to connect a socket',
															'fatal: The remote end hung up unexpectedly'];

		public function GitHubApiProxy()
		{
			super.executable = 'GitHubApi.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_PROGRESS, onProcessProgress);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function getAccountInfo():void
		{
			super.call(Vector.<String>([BashMethods.GET_ACCOUNT_INFO]));
		}
		
		public function login($name:String, $pass:String):void
		{
			super.call(Vector.<String>([BashMethods.LOGIN, $name, $pass]));
		}
		
		public function logout():void
		{
			super.call(Vector.<String>([BashMethods.LOGOUT]));
		}		
		
		public function clone(url:String, loc:String):void
		{
			super.call(Vector.<String>([BashMethods.CLONE_REPOSITORY, url, loc]));
		}
		
		public function addRepository($name:String, $desc:String, $public:Boolean):void
		{
			super.call(Vector.<String>([BashMethods.ADD_REPOSITORY, $name, $desc, $public]));
		}

		public function getRepositories():void
		{
			super.call(Vector.<String>([BashMethods.GET_REPOSITORIES]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.LOADER_TEXT, 'Fetching Repositories'));
		}
		
	// response handlers - native process exit //			
		
		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
	//		trace("GithubApiProxy.handleProcessSuccess(e)", e.data.method);
			var o:Object = getResultObject(e.data.result);
			if (o.message){
				onMessage(e.data.method, o);
			}	else{
				onSuccess(e.data.method, o);
			}
		}
		
		private function handleProcessFailure(e:NativeProcessEvent):void
		{
	//		trace("GithubApiProxy.handleProcessFailure(e)", e.data.method, e.data.result);
			var errorHandled:Boolean = false;
			for (var i:int = 0; i < _connectionErrors.length; i++) {
				if (e.data.result.indexOf(_connectionErrors[i] != -1)){
					errorHandled = true;
					dispatchAlert('Could not find remote repository, please check your internet connection & the repository URL.');
				}
			}
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			if (!errorHandled) dispatchDebug(e.data);
		}
		
		private function getResultObject(s:String):Object
		{
		// strip off any post headers we receive before parsing json //	
			if (s.indexOf('[') != -1) {
				return new JSONDecoder(s.substr(s.indexOf('[')), false).getValue();
			}	else if (s.indexOf('{') != -1){
				return new JSONDecoder(s.substr(s.indexOf('{')), false).getValue();
			}	else{
				return {result:s};
			}					
		}
		
		private function onSuccess(m:String, o:Object):void
		{
		//	trace("GitHubApiProxy.onSuccess(m, o)", m, o);
			switch(m){
				case BashMethods.GET_ACCOUNT_INFO :
					login(o.user, o.pass);
				break;
				case BashMethods.LOGIN :
					_accountData = o;
					_accountData.type = RemoteAccount.GITHUB;
					AppModel.proxies.githubKey.validateKeys(o.login);
				break;
				case BashMethods.LOGOUT:
					AccountManager.killAccount(AccountManager.github);					
					dispatchEvent(new AppEvent(AppEvent.LOGOUT));
				break;									
				case BashMethods.GET_REPOSITORIES :
					_accountData.repos = o as Array;
					AccountManager.addAccount(new RemoteAccount(_accountData));
				break;
				case BashMethods.CLONE_REPOSITORY :
					dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
				break;	
				case BashMethods.ADD_REPOSITORY :
					dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, o.ssh_url));
				break;								
			}
		}
		
		private function onMessage(m:String, o:Object):void
		{
		//	trace("GitHubApiProxy.onMessage(m, o)", m, o.message);
			switch(o.message){
				case 'No connection' :
					dispatchEvent(new AppEvent(AppEvent.OFFLINE));
				break;
				case 'Bad credentials' :
					dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILED));
				break;
				case 'Clone complete' :				
					dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
				break;
				case 'Account info unavailable' : 
					// attempt to auto-login failed, ignore this error.
					trace('GithubApiProxy :: no github credentials found');
				break;				
				default :
					o.method = m;
					dispatchDebug(o);
				break;						
			}
		}
		
	// handle native process responses //			

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}	
		
		private function onProcessProgress(e:NativeProcessEvent):void
		{
		//	trace("progress = "+e.data.result);
		}			
		
		private function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));				
		}		
		
		private function dispatchDebug(o:Object):void
		{
			o.source = 'GithubApiProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));
		}
		
	}
	
}
