package view.modals.login {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.Form;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class GitHubLogin extends AccountLogin {

		private static var _view 	:GitHubLoginMC = new GitHubLoginMC();
		private static var _form	:Form = new Form(new Form2());

		public function GitHubLogin()
		{
			super(_view);
			super.drawBackground(550, 250);
			super.setTitle(_view, 'Login To Github');
			super.setHeading(_view, 'Have a GitHub account? Please login. (Required for private repositories)');
			_form.labels = ['Username', 'Password'];
			_form.inputs = [_view.name_txt, _view.pass_txt];
			_form.y = 90; addChild(_form);
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (_form.validate()){
				super.lockScreen();
				var a:HostingAccount = new HostingAccount({type:HostingAccount.GITHUB, 
						acct:_form.fields[0], user:_form.fields[0], pass:_form.fields[1]});						
				Hosts.github.attemptLogin(a, super.saveAccount);
				Hosts.github.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			}			
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			super.dispatchLoginSuccessEvent();
			Hosts.github.api.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}		
				
		override protected function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest('https://github.com/signup'));
		}
		
	}
	
}
