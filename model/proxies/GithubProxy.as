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

		private static var _userName	:String;
		private static var _userPass	:String;

		public function GithubProxy()
		{
			super.executable = 'Github.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function login($name:String, $pass:String):void
		{
			_userName = $name; _userPass = $pass;
			super.call(Vector.<String>([BashMethods.LOGIN, _userName, _userPass]));
		}
		
		private function getRepositories():void
		{
			super.call(Vector.<String>([BashMethods.REPOSITORIES, _userName, _userPass]));		
		}		
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			if (e.data.result != ''){
				parseResults(e.data.result, e.data.method);
			}	else{
				dispatchEvent(new AppEvent(AppEvent.OFFLINE));
			}
		}
		
		private function parseResults(r:String, m:String):void
		{
			var o:Object = new JSONDecoder(r, false).getValue();
			if(o.message){
				onRequestFailure(m, o);	
			}	else{
				onRequestSuccess(m, o);
			}			
		}
		
		private function onRequestSuccess(m:String, o:Object):void
		{
			switch(m){
				case BashMethods.LOGIN : 
					addNewAccount(o); 
					getRepositories();
				break;	
				case BashMethods.REPOSITORIES :
					onRepositories(o);
				break;								
			}
		}

		private function addNewAccount(o:Object):void
		{
			o.pass = _userPass;
			o.type = RemoteAccount.GITHUB;
			AccountManager.addAccount(new RemoteAccount(o));
		}
		
		private function onRepositories(o:Object):void
		{
			AccountManager.github.repositories = o as Array;
			dispatchEvent(new AppEvent(AppEvent.GITHUB_READY));
		}		

		private function onRequestFailure(m:String, o:Object):void
		{
			trace("GithubProxy.onRequestFailure(o)", m);
			if (o.message == 'Bad credentials') dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILED));
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'GithubProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}

	}
	
}
