package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GitHubLogin extends LoginScreen {

		private static var _onSuccessEvent		:String;

		public function GitHubLogin()
		{
			super.view.github.visible = true;		
			super.setTextFields('Github');
			super.addBadge(new GitLoginBadge());
			super.view.github.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
			AppModel.proxies.githubApi.addEventListener(AppEvent.LOGOUT, onLogout);			
		}
		
		public function set onSuccessEvent(e:String):void 
		{ 
			_onSuccessEvent = e;
			super.allowSkip = (e != UIEvent.ADD_REMOTE_TO_BOOKMARK);
		}		

		private function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('https://github.com/signup'));			
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (!validate()) return;
			if (AccountManager.github){
				AppModel.proxies.githubApi.logout();
				AppModel.proxies.githubApi.addEventListener(AppEvent.LOGOUT, onLogout);
			}	else{
				lockScreen();
				AppModel.proxies.githubApi.login(super.view.name_txt.text, super.view.pass_txt.text);				
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
