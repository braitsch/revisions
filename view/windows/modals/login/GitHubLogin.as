package view.windows.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.type.TextHeading;
	import view.windows.base.ParentWindow;

	public class GitHubLogin extends ParentWindow {

		private static var _login	:AccountLogin = new AccountLogin(HostingAccount.GITHUB);
		private static var _heading	:TextHeading = new TextHeading();

		public function GitHubLogin()
		{
			super.addCloseButton();
			super.drawBackground(550, 250);
			super.title = 'Login To Github';
			
			_heading.text = 'Have a GitHub account? Please login.';
			addChild(_heading);
			
			_login.y = 70;
			_login.baseline = 250;
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			addChild(_login);
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
		}
		
	}
	
}
