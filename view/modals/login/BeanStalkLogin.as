package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.RemoteAccount;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	public class BeanstalkLogin extends BaseAccountLogin {

		private static var _view				:AccountLoginMC = new AccountLoginMC();
		private static var _onSuccessEvent		:String;

		public function BeanstalkLogin()
		{
			super(_view);
			super.setTextFields('Beanstalk');
			super.setTitle(_view, 'Login To Beanstalk');
			super.accountBtn = new BeanStalkButton();
		}
		
		public function set onSuccessEvent(e:String):void 
		{ 
			_onSuccessEvent = e;
		}
		
		override protected function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));			
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void 
		{ 
			if (validate()){
				lockScreen();
				AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
				dispatchEvent(new AppEvent(AppEvent.ATTEMPT_LOGIN, {user:super.name, pass:super.pass}));
			}
		}		
		
		private function onLoginSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(_onSuccessEvent, RemoteAccount.GITHUB));
			AppModel.engine.removeEventListener(AppEvent.REMOTE_READY, onLoginSuccess);			
		}			
		
	}
	
}
