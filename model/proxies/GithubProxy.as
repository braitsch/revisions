package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import system.BashMethods;
	import com.adobe.serialization.json.JSONDecoder;

	public class GithubProxy extends NativeProcessProxy {

		public function GithubProxy()
		{
			super.executable = 'GitHub.sh';
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
			super.call(Vector.<String>([BashMethods.CLONE, url, loc]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Connecting to Remote Repository'));
		}

		public function getRepositories():void
		{
			super.call(Vector.<String>([BashMethods.REPOSITORIES]));
		}
		
	// response handlers - native process exit //			
		
		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
			trace("GithubProxy.handleProcessSuccess(e)", e.data.method);
			var o:Object = getResultObject(e.data.result);
			if (o.message){
				onMessage(e.data.method, o);
			}	else{
				onSuccess(e.data.method, o);
			}
		}
		
		private function getResultObject(s:String):Object
		{
			if (s.indexOf('[') == 0 || s.indexOf('{') == 0){
				return new JSONDecoder(s, false).getValue();
			}	else{
				return {result:s};
			}
		}

		private function handleProcessFailure(e:NativeProcessEvent):void
		{
			trace("GithubProxy.handleProcessFailure(e)", e.data.method);
			switch(e.data.result){
				case 'fatal: The remote end hung up unexpectedly' :
					dispatchAlert('Could not find remote repository, please check the URL.');
				break;
				default :
					dispatchDebug(e.data.method, e.data.result);
				break;
			}
		}
		
		private function onSuccess(m:String, o:Object):void
		{
			switch(m){
				case BashMethods.GET_ACCOUNT_INFO :
					login(o.user, o.pass);
				break;
				case BashMethods.LOGIN :
					addNewAccount(o); 
					AppModel.proxies.ssh.detectSSHKeys();
				break;					
				case BashMethods.REPOSITORIES :
					onRepositories(o);
				break;
				case BashMethods.CLONE :
					dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
				break;				
			}
		}
		
		private function onMessage(m:String, o:Object):void
		{
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
				break;				
				default :
					dispatchDebug(m, o.message);
				break;						
			}
		}		

		private function addNewAccount(o:Object):void
		{
			o.type = RemoteAccount.GITHUB;
			AccountManager.addAccount(new RemoteAccount(o));
		}
		
		private function onRepositories(o:Object):void
		{
			AccountManager.github.repositories = o as Array;
			dispatchEvent(new AppEvent(AppEvent.GITHUB_READY));
		}
		
	// handle native process responses //			

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}	
		
		private function onProcessProgress(e:NativeProcessEvent):void
		{
			trace("progress = "+e.data.result);
		}			
		
		private function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));				
		}		
		
		private function dispatchDebug(m:String, r:String):void
		{
			var s:String = 'GithubProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:m, r:r}));				
		}
		
	}
	
}
