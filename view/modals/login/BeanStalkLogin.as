package view.modals.login {

	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	public class BeanStalkLogin extends BaseAccountLogin {

		private static var _view				:AccountLoginMC = new AccountLoginMC();
		private static var _onSuccessEvent		:String;

		public function BeanStalkLogin()
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
			if (!validate()) return;
			lockScreen();
		//TODO need to obviously request this against the beanstalk api...	
		//	AppModel.proxies.githubApi.login(_view.name_txt.text, _view.pass_txt.text);	
		}				
		
	}
	
}
