package view.modals.login {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class GitHubLogin extends AccountLogin {

		private static var _view :GitHubLoginMC = new GitHubLoginMC();

		public function GitHubLogin()
		{
			super(_view);
			super.drawBackground(550, 250);
			super.setTitle(_view, 'Login To Github');
			super.setHeading(_view, 'Have a GitHub account? Please login. (Required for private repositories)');
			super.labels = ['Username', 'Password'];
			super.fields = [_view.name_txt, _view.pass_txt];
			_view.name_txt.text = 'braitsch'; _view.pass_txt.text = 'aelisch76';
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (super.validate()){
				super.lockScreen();
				var ha:HostingAccount = new HostingAccount({type:HostingAccount.GITHUB, 
						acct:super.fields[0], user:super.fields[0], pass:super.fields[1]});						
				dispatchEvent(new AppEvent(AppEvent.LOGIN, ha));		
			}			
		}
		
		override protected function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest('https://github.com/signup'));
		}
		
	}
	
}
