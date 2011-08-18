package model.remote {

	import events.AppEvent;
	import model.proxies.remote.GitHubProxy;
	import model.proxies.remote.KeyProxy;
	import view.modals.login.GitHubLogin;
	import view.modals.remote.AccountHome;
	import view.modals.remote.AddBkmkToGitHub;
	import view.modals.remote.GitHubHome;
	
	public class GitHub {
		
		private static var _key 		:KeyProxy = new KeyProxy();
		private static var _user 		:GitHubProxy = new GitHubProxy();
		private static var _home 		:GitHubHome	= new GitHubHome(_user);
		private static var _login 		:GitHubLogin = new GitHubLogin();
		private static var _addRepo		:AddBkmkToGitHub = new AddBkmkToGitHub(_user);

		public function GitHub()
		{
			_login.addEventListener(AppEvent.ATTEMPT_LOGIN, attemptLogin);
		}

		private function attemptLogin(e:AppEvent):void
		{
			e.data.type = RemoteAccount.GITHUB;
			_user.login(new RemoteAccount(e.data));
		}
		
		public function get key():KeyProxy
		{
			return _key;
		}

		public function get user():GitHubProxy
		{
			return _user;
		}

		public function get home():AccountHome
		{
			return _home;
		}

		public function get login():GitHubLogin
		{
			return _login;
		}

		public function get addRepo():AddBkmkToGitHub
		{
			return _addRepo;
		}
		
		
	}
	
	
}
