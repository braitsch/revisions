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
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
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
		}		
		
		public function getRepositories():void
		{
			super.call(Vector.<String>([BashMethods.REPOSITORIES]));
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("GithubProxy.onProcessComplete(e)", e.data.method);
			var o:Object = new JSONDecoder(e.data.result, false).getValue();
			if(o.message){
				onMessage(o.message);
			}	else{
				onSuccess(e.data.method, o);
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
			}
		}
		
		private function onMessage(m:String):void
		{
			trace("GithubProxy.onMessage(m)", m);
			switch(m){
				case 'No connection' :
					dispatchEvent(new AppEvent(AppEvent.OFFLINE));
				break;
				case 'Bad credentials' :
					dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILED));
				break;
				case 'Clone complete' :				
					dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
				break;
				case 'Account info unavailable' : break;				
				default :
					dispatchDebug('', m);
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
		
	// handle failures //			

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			dispatchDebug(e.data.method, e.data.result);
		}
		
		private function dispatchDebug(m:String, r:String):void
		{
			var s:String = 'GithubProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:m, r:r}));				
		}
		
	}
	
}
