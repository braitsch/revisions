package view.modals.login {

	import model.remote.HostingAccount;
	import view.modals.base.ModalWindow;

	public class BeanstalkLogin extends ModalWindow {

		private static var _view 	:BeanstalkLoginMC = new BeanstalkLoginMC();
		private static var _login	:AccountLogin = new AccountLogin(HostingAccount.BEANSTALK);

		public function BeanstalkLogin()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 280);
			super.setTitle(_view, 'Login To Beanstalk');
			_login.y = 70; _view.addChildAt(_login, 0);
		//	_login.inputs = [_view.acct_txt, _view.name_txt, _view.pass_txt];
			_login.heading = 'Have a Beanstalk account? Please login.';
		}
		
		override public function onEnterKey():void { _login.onLoginButton(); }
		public function set onSuccessEvent(s:String):void { _login.onSuccessEvent = s; }		

	}
	
}
