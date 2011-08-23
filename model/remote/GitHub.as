package model.remote {

	import events.AppEvent;
	import model.proxies.remote.acct.AccountProxy;
	import model.proxies.remote.acct.GitHubProxy;
	import model.proxies.remote.keys.GHKeyProxy;
	import view.modals.remote.AccountHome;
	import view.modals.remote.GitHubHome;
	
	public class GitHub extends HostingProvider {
		
		private static var _type		:String = HostingAccount.GITHUB;
		private static var _proxy 		:GitHubProxy = new GitHubProxy();
		private static var _home 		:GitHubHome	= new GitHubHome(_proxy);
		
		private static var _loginObj	:Object = {	title	:	'Login To Github',
													button	:	new GitHubButton(), 
													signup	:	'https://github.com/signup' };
													
		private static var _addRepoObj	:Object = {	title	:	'Add To Github', 
													option	:	'Make Repository Private'	};				

		public function GitHub()
		{
			super(new GHKeyProxy());
			_proxy.addEventListener(AppEvent.LOGIN_SUCCESS, super.onLoginSuccess);
			_proxy.addEventListener(AppEvent.LOGOUT_SUCCESS, super.onLogoutSuccess);
		}
		
		override public function get type():String { return _type; }

		override public function get home():AccountHome { return _home; }
		
		override public function get proxy():AccountProxy { return _proxy; }

		override public function get loginObj():Object { return _loginObj; }
		
		override public function get addRepoObj():Object { return _addRepoObj; }
		
	}
	
}
