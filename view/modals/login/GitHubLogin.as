package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import model.AppModel;
	import model.remote.Accounts;
	import model.remote.RemoteAccount;
	
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
			super.allowSkip = (e != UIEvent.ADD_REMOTE_TO_BOOKMARK);
		}	
		
		override protected function gotoNewAccountPage(e:MouseEvent):void
		{
			navigateToURL(new URLRequest('https://github.com/signup'));			
		}
		
		override protected function onLoginButton(e:MouseEvent = null):void
		{
			if (!validate()) return;
			lockScreen();
			var a:RemoteAccount = Accounts.getAccountByName(RemoteAccount.GITHUB, super.name);
			var o:Object = {type:RemoteAccount.GITHUB, user:super.name, pass:super.pass, sshKeyId:a ? a.sshKeyId : 0};
			AppModel.proxies.ghLogin.login(new RemoteAccount(o));
		}
		
		override protected function onLoginSuccess(e:AppEvent):void
		{
			unlockScreen();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));			
			dispatchEvent(new UIEvent(_onSuccessEvent, RemoteAccount.GITHUB));
		}		
		
	}
	
}
