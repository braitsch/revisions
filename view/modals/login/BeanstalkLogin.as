package view.modals.login {

	import events.UIEvent;
	import events.AppEvent;
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
			_login.baseline = 280;
			_login.heading = 'Have a Beanstalk account? Please login.';
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
		}
		
	}
	
}
