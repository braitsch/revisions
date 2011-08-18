package model.remote {

	import events.AppEvent;
	import model.proxies.remote.AccountProxy;
	import model.proxies.remote.GitHubProxy;
	import model.proxies.remote.KeyProxy;
	import view.modals.remote.AccountHome;
	import view.modals.remote.AddBkmkToAccount;
	import view.modals.remote.AddBkmkToGitHub;
	import view.modals.remote.GitHubHome;
	
	public class GitHub extends HostingProvider {
		
		private static var _type		:String = Account.GITHUB;
		private static var _proxy 		:GitHubProxy = new GitHubProxy();
		private static var _home 		:GitHubHome	= new GitHubHome(_proxy);
		private static var _addRepo		:AddBkmkToGitHub = new AddBkmkToGitHub(_proxy);
		
		private static var _loginObj	:Object = {	title	:	'Login To Github',
													button	:	new GitHubButton(), 
													signup	:	'https://github.com/signup' };

		public function GitHub()
		{
			super(new KeyProxy());
			_proxy.addEventListener(AppEvent.LOGIN_SUCCESS, super.onLoginSuccess);
			_proxy.addEventListener(AppEvent.LOGOUT_SUCCESS, super.onLogoutSuccess);
		}
		
		override public function get type():String { return _type; }

		override public function get proxy():AccountProxy { return _proxy; }

		override public function get home():AccountHome { return _home; }

		override public function get addRepo():AddBkmkToAccount { return _addRepo; }

		override public function get loginObj():Object { return _loginObj; }
		
	}
	
}
