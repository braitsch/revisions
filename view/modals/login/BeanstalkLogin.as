package view.modals.login {

	import events.AppEvent;
	import events.ErrEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindow;
	import view.ui.TextHeading;

	public class BeanstalkLogin extends ModalWindow {

		private static var _view 	:BeanstalkLoginMC = new BeanstalkLoginMC();
		private static var _login	:AccountLogin = new AccountLogin(HostingAccount.BEANSTALK);
		private static var _heading	:TextHeading = new TextHeading();

		public function BeanstalkLogin()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 280);
			super.setTitle(_view, 'Login To Beanstalk');
			
			_heading.text = 'Have a Beanstalk account? Please login.';
			addChild(_heading);
		
			_login.y = 70; _view.addChildAt(_login, 0);
			_login.baseline = 280;
			_login.addEventListener(AppEvent.ATTEMPT_LOGIN, onAttemptLogin);
		}

		private function onAttemptLogin(e:AppEvent):void
		{
			AppModel.engine.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			AppModel.engine.addEventListener(ErrEvent.LOGIN_FAILURE, onLoginFailure);			
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			removeListeners();
			dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
		}
		
		private function onLoginFailure(e:ErrEvent):void
		{
			removeListeners();	
		}

		private function removeListeners():void
		{
			AppModel.engine.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			AppModel.engine.removeEventListener(ErrEvent.LOGIN_FAILURE, onLoginFailure);			
		}
		
	}
	
}
