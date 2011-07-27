package view.modals.remote {

	import model.AppModel;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GitHubLogin extends LoginScreen {

		public function GitHubLogin()
		{
			super.view.github.visible = true;		
			super.setTextFields('Github');
			super.addBadge(new GitLoginBadge());
			super.view.github.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
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
		
	}
	
}
