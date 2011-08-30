package model.remote {

	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.GitHubApi;
	import model.proxies.remote.keys.GitHubKey;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.login.AccountLogin;
	import view.modals.login.GitHubLogin;
	import view.modals.remote.AccountHome;
	import view.modals.remote.GitHubHome;
	
	public class GitHub implements IHostingProvider {
		
		private var _type			:String = HostingAccount.GITHUB;
		private var _api 			:GitHubApi = new GitHubApi();
		private var _key 			:GitHubKey = new GitHubKey();		
		private var _home 			:GitHubHome	= new GitHubHome();
		private var _login			:GitHubLogin = new GitHubLogin();
		
		private var _addRepoObj		:Object = {	title	:	'Add To Github', 
												option	:	'Make Repository Private'	};				
		
		public function get type()			:String				{ return _type; 		}
		public function get api()			:ApiProxy 			{ return _api; 			}
		public function get key()			:KeyProxy 			{ return _key;			}
		public function get home()			:AccountHome		{ return _home; 		}
		public function get login()			:AccountLogin 		{ return _login; 		}
		public function get addRepoObj()	:Object				{ return _addRepoObj; 	}			
		
	}
	
}
