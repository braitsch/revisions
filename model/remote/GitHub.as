package model.remote {

	import model.proxies.remote.acct.GitHubApi;
	import model.proxies.remote.keys.GitHubKey;
	import view.modals.login.GitHubLogin;
	import view.modals.remote.GitHubHome;
	
	public class GitHub {
		
		public var type			:String = HostingAccount.GITHUB;
		public var api 			:GitHubApi = new GitHubApi();
		public var key 			:GitHubKey = new GitHubKey();		
		public var home 		:GitHubHome	= new GitHubHome();
		public var login		:GitHubLogin = new GitHubLogin();
		
		public var addRepoObj	:Object = {	title	:	'Add To Github', 
													option	:	'Make Repository Private'	};				
		
	}
	
}
