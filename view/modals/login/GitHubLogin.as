package view.modals.login {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class GitHubLogin extends AccountLogin {

		private static var _view :GitHubLoginMC = new GitHubLoginMC();

		public function GitHubLogin()
		{
			super(_view);
			super.drawBackground(550, 250);
			super.setTitle(_view, 'Login To Github');
			super.setHeading(_view, 'Have a GitHub account? Please login. (Required for private repositories)');
			super.labels = ['Username', 'Password'];
			super.fields = [_view.name_txt, _view.pass_txt];
			_view.name_txt.text = 'braitsch'; _view.pass_txt.text = 'aelisch76';
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (super.validate()){
				super.lockScreen();
				Hosts.github.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
				Hosts.github.api.login(new HostingAccount({type:HostingAccount.GITHUB, 
						acct:super.fields[0], user:super.fields[0], pass:super.fields[1]}));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Attemping Login'}));
			}			
		}
		
		private function onLoginSuccess(e:AppEvent):void 
		{ 
			super.unlockScreen(); 
			Hosts.github.home.model = e.data as HostingAccount;
			Hosts.github.api.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			super.dispatchLoginSuccessEvent();
		}		
		
		override protected function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest('https://github.com/signup'));
		}
		
	}
	
}
