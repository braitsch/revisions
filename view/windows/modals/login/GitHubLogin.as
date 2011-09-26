package view.windows.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.ui.TextHeading;
	import view.windows.base.ParentWindow;

	public class GitHubLogin extends ParentWindow {

		private static var _view 	:GitHubLoginMC = new GitHubLoginMC();
		private static var _login	:AccountLogin = new AccountLogin(HostingAccount.GITHUB);
		private static var _heading	:TextHeading = new TextHeading();

		public function GitHubLogin()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 250);
			super.setTitle(_view, 'Login To Github');
			
			_heading.text = 'Have a GitHub account? Please login.';
			addChild(_heading);
			
			_login.y = 70; _view.addChildAt(_login, 0);
			_login.baseline = 250;
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
		}
		
	}
	
}
