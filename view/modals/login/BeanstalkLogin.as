package view.modals.login {

	import view.ui.Form;
	import events.AppEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class BeanstalkLogin extends AccountLogin {

		private static var _view 	:BeanstalkLoginMC = new BeanstalkLoginMC();
		private static var _form	:Form = new Form(new Form3());

		public function BeanstalkLogin()
		{
			super(_view);
			super.drawBackground(550, 280);
			super.setTitle(_view, 'Login To Beanstalk');
			super.setHeading(_view, 'Have a Beanstalk account? Please login.');
			_form.labels = ['Account', 'Username', 'Password'];
			_form.inputs = [_view.acct_txt, _view.name_txt, _view.pass_txt];
			_form.y = 90; addChild(_form);
			_form.deactivateFields(['field2']);
		}

		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (_form.validate()){
				super.lockScreen();
				var a:HostingAccount = new HostingAccount({type:HostingAccount.BEANSTALK, 
						acct:_form.fields[0], user:_form.fields[1], pass:_form.fields[2]});
				Hosts.beanstalk.attemptLogin(a, super.saveAccount);
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
