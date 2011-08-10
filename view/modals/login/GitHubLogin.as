package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import model.AppModel;
	import model.remote.Accounts;
	import model.remote.RemoteAccount;
	
	public class GitHubLogin extends BaseAccountLogin {

		private static var _view				:AccountLoginMC = new AccountLoginMC();
		private static var _onSuccessEvent		:String;

		public function GitHubLogin()
		{
			super(_view);
			super.setTextFields('Github');
			super.setTitle(_view, 'Login To Github');
			super.accountBtn = new GitHubButton();
			AppModel.proxies.githubApi.addEventListener(AppEvent.LOGOUT, onLogout);			
		}

		public function set onSuccessEvent(e:String):void 
		{ 
			_onSuccessEvent = e;
			super.allowSkip = (e != UIEvent.ADD_REMOTE_TO_BOOKMARK);
		}	
		
		override protected function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('https://github.com/signup'));			
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (!validate()) return;
			if (Accounts.github.loggedIn){
				AppModel.proxies.githubApi.logout();
				AppModel.proxies.githubApi.addEventListener(AppEvent.LOGOUT, onLogout);
			}	else{
				lockScreen();
			// check db account for a match and retrieve ssh-key-id	
				var o:Object = {type:RemoteAccount.GITHUB, user:super.name, pass:super.pass};
				var a:RemoteAccount = new RemoteAccount(o);
				AppModel.proxies.githubApi.login(a);
			}
		}
		
		private function onLogout(e:AppEvent):void
		{
			onLoginButton();
			AppModel.proxies.githubApi.removeEventListener(AppEvent.LOGOUT, onLogout);
		}
		
		override protected function onLoginSuccess(e:AppEvent):void
		{
			unlockScreen();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));			
			dispatchEvent(new UIEvent(_onSuccessEvent, RemoteAccount.GITHUB));
		}		
		
	}
	
}
