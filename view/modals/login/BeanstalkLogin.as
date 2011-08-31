package view.modals.login {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class BeanstalkLogin extends AccountLogin {

		private static var _view :BeanstalkLoginMC = new BeanstalkLoginMC();

		public function BeanstalkLogin()
		{
			super(_view);
			super.drawBackground(550, 280);
			super.setTitle(_view, 'Login To Beanstalk');
			super.setHeading(_view, 'Have a Beanstalk account? Please login.');
			super.labels = ['Account', 'Username', 'Password'];
			super.inputs = [_view.acct_txt, _view.name_txt, _view.pass_txt];
			_view.acct_txt.text = 'braitsch';
			_view.name_txt.text = 'braitsch'; _view.pass_txt.text = 'aelisch76';
		}

		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (super.validate()){
				super.lockScreen();
				var a:HostingAccount = new HostingAccount({type:HostingAccount.BEANSTALK, 
						acct:super.fields[0], user:super.fields[1], pass:super.fields[2]});
				Hosts.beanstalk.attemptLogin(a, true);
				Hosts.beanstalk.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			}			
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			super.dispatchLoginSuccessEvent();
			Hosts.beanstalk.api.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}		
		
		override protected function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));
		}
		
	}
	
}
