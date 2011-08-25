package model.remote {

	import events.AppEvent;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.GitHubApi;
	import model.proxies.remote.keys.GitHubKey;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.login.AccountLogin;
	import view.modals.login.GitHubLogin;
	import view.modals.remote.AccountHome;
	import view.modals.remote.GitHubHome;
	
	public class GitHub extends HostingProvider {
		
		private static var _type		:String = HostingAccount.GITHUB;
		private static var _api 		:GitHubApi = new GitHubApi();
		private static var _key 		:GitHubKey = new GitHubKey();		
		private static var _home 		:GitHubHome	= new GitHubHome(_api);
		private static var _login		:GitHubLogin = new GitHubLogin();
		
		private static var _addRepoObj	:Object = {	title	:	'Add To Github', 
													option	:	'Make Repository Private'	};				

		public function GitHub()
		{
			super(_key);
			_api.addEventListener(AppEvent.LOGIN_SUCCESS, super.onLoginSuccess);
			_api.addEventListener(AppEvent.LOGOUT_SUCCESS, super.onLogoutSuccess);
		}
		
		override public function get type():String { return _type; }

		override public function get home():AccountHome { return _home; }
		
		override public function get login():AccountLogin { return _login; }
		
		override public function get api():ApiProxy { return _api; }
		
		override public function get key():KeyProxy { return _key; }

		override public function get addRepoObj():Object { return _addRepoObj; }
		
	}
	
}
