package view.modals.login {

	import model.remote.HostingAccount;
	import view.modals.base.ModalWindow;

	public class GitHubLogin extends ModalWindow {

		private static var _view 	:GitHubLoginMC = new GitHubLoginMC();
		private static var _login	:AccountLogin = new AccountLogin(HostingAccount.GITHUB);

		public function GitHubLogin()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 250);
			super.setTitle(_view, 'Login To Github');
			_login.y = 70; _view.addChildAt(_login, 0);
		//	_login.inputs = [_view.name_txt, _view.pass_txt];
			_login.heading = 'Have a GitHub account? Please login. (Required for private repositories)';
		}
		
		override public function onEnterKey():void { _login.onLoginButton(); }
		public function set onSuccessEvent(s:String):void { _login.onSuccessEvent = s; }
		
	}
	
}
