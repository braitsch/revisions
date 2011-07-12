package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import com.adobe.serialization.json.JSONDecoder;

	public class GithubProxy extends NativeProcessProxy {

		private static var _userName:String;
		private static var _userPass:String;

		public function GithubProxy()
		{
			super.executable = 'Github.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function login($name:String, $pass:String):void
		{
			trace("GithubProxy.login", $name, $pass);
			_userName = $name; _userPass = $pass;
			super.call(Vector.<String>(['login', _userName, _userPass]));
		}
		
		private function getRepositories():void
		{
			super.call(Vector.<String>(['getRepositories', _userName, _userPass]));		
		}		
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("GithubProxy.onProcessComplete(e)", e.data.method);
			var o:Object = new JSONDecoder(e.data.result, false).getValue();
			if(o.message){
				onHandleError(e.data.method, o);	
			}	else{
				onHandleSuccess(e.data.method, o);
			}
		}
		
		private function onHandleSuccess(m:String, o:Object):void
		{
			switch(m){
				case 'login' :
					addNewAccount(o);
				break;	
				case 'getRepositories' :
					onRepositories(o);
				break;								
			}
		}

		private function addNewAccount(o:Object):void
		{
			o.pass = _userPass;
			o.type = RemoteAccount.GITHUB;
			AccountManager.addAccount(new RemoteAccount(o));
			getRepositories();
		}
		
		private function onRepositories(o:Object):void
		{
			AccountManager.github.repositories = o as Array;
			dispatchEvent(new AppEvent(AppEvent.GITHUB_DATA));
		}		

		private function onHandleError(m:String, o:Object):void
		{
			trace("GithubProxy.onHandleError(o)", m);
			if (o.message == 'Bad credentials') trace('login failed');
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'GithubProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}

	}
	
}
