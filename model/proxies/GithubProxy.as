package model.proxies {

	import model.db.AppSettings;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import com.adobe.serialization.json.JSONDecoder;
	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;

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
			_userName = $name; _userPass = $pass;
			super.call(Vector.<String>(['login', _userName, _userPass]));			
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("GithubProxy.onProcessComplete(e)", e.data.method);
			var o:Object = new JSONDecoder(e.data.result, false).getValue();
			if(o.message){
				onHandleError(o);	
			}	else{
				addNewAccount(o);
			}
		}
		
		private function addNewAccount(o:Object):void
		{
			var ra:RemoteAccount = new RemoteAccount(RemoteAccount.GITHUB, _userName, _userPass, o.avatar_url);
			AccountManager.addAccount(ra);
			AppSettings.setSetting(AppSettings.GITHUB_USER, _userName);
			AppSettings.setSetting(AppSettings.GITHUB_PASS, _userPass);
		}
		
		private function onHandleError(o:Object):void
		{
			if (o.message == 'Bad credentials') trace('login failed');
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'GithubProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}
		
	}
	
}
