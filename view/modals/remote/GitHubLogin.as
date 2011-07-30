package view.modals.remote {

	import model.remote.RemoteAccount;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GitHubLogin extends LoginScreen {

		private var _onSuccessEvent		:String;

		public function GitHubLogin()
		{
			super.view.github.visible = true;		
			super.setTextFields('Github');
			super.addBadge(new GitLoginBadge());
			super.view.github.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
		}
		
		public function set onSuccessEvent(e:String):void 
		{ 
			_onSuccessEvent = e;
			super.allowSkip = (e != UIEvent.ADD_REMOTE);
		}		

		private function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('https://github.com/signup'));			
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (!validate()) return;
			lockScreen();
			AppModel.proxies.githubApi.login(super.view.name_txt.text, super.view.pass_txt.text);	
		}
		
		override protected function onLoginSuccess(e:AppEvent):void
		{
			unlockScreen();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));			
			dispatchEvent(new UIEvent(_onSuccessEvent, RemoteAccount.GITHUB));
		}		
		
	}
	
}
