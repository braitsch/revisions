package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.remote.Account;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GitHubLogin extends BaseAccountLogin {

		private static var _view				:AccountLoginMC = new AccountLoginMC();
		private static var _onSuccessEvent		:String;

		public function GitHubLogin()
		{
			super(_view);
			super.setTextFields('Github');
			super.setTitle(_view, 'Login To Github');
			super.accountBtn = new GitHubButton();
		}

		public function set onSuccessEvent(e:String):void 
		{ 
			_onSuccessEvent = e;
		}	
		
		override protected function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('https://github.com/signup'));			
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
			dispatchEvent(new UIEvent(_onSuccessEvent, {type:Account.GITHUB}));
			Hosts.github.home.model = e.data as Account;
			AppModel.engine.removeEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
		}					
		
	}
	
}
