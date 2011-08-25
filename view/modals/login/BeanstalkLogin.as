package view.modals.login {

	import events.AppEvent;
	import model.AppModel;
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
			super.fields = [_view.acct_txt, _view.name_txt, _view.pass_txt];
			_view.acct_txt.text = 'beanstalk';
			_view.name_txt.text = 'braitsch'; _view.pass_txt.text = 'aelisch76';
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (super.validate()){
				super.lockScreen();
				Hosts.beanstalk.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
				Hosts.beanstalk.api.login(new HostingAccount({type:HostingAccount.BEANSTALK, 
						acct:super.fields[0], user:super.fields[1], pass:super.fields[2]}));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Attemping Login'}));
			}			
		}
		
		private function onLoginSuccess(e:AppEvent):void 
		{ 
			super.unlockScreen(); 
			Hosts.beanstalk.home.model = e.data as HostingAccount;
			Hosts.beanstalk.api.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			super.dispatchLoginSuccessEvent();
		}		
		
		override protected function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));
		}
		
	}
	
}
