package view.modals.remote {


	import model.AppModel;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	public class BeanStalkLogin extends LoginScreen {

		public function BeanStalkLogin()
		{
			super.view.beanstalk.visible = true;
			super.setTextFields('Beanstalk');
			super.addBadge(new BeanstalkLoginBadge());
			super.view.beanstalk.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
		}

		private function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));			
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (!validate()) return;
			lockScreen();
		//TODO need to obviously request this against the beanstalk api...	
			AppModel.proxies.githubApi.login(super.view.name_txt.text, super.view.pass_txt.text);	
		}				
		
	}
	
}
