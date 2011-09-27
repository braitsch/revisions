package view.windows.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.type.TextHeading;
	import view.windows.base.ParentWindow;

	public class BeanstalkLogin extends ParentWindow {

		private static var _login	:AccountLogin = new AccountLogin(HostingAccount.BEANSTALK);
		private static var _heading	:TextHeading = new TextHeading();

		public function BeanstalkLogin()
		{
			super.addCloseButton();
			super.drawBackground(550, 280);
			super.title = 'Login To Beanstalk';
			
			_heading.text = 'Have a Beanstalk account? Please login.';
			addChild(_heading);
		
			_login.y = 70;
			_login.baseline = 280;
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			addChild(_login);
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
		}
		
	}
	
}
