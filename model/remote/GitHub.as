package model.remote {

	import view.windows.account.base.AccountBase;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.GitHubApi;
	import model.proxies.remote.acct.GitHubKey;
	import model.proxies.remote.acct.KeyProxy;
	import view.windows.account.github.GHAcctView;
	import view.windows.base.ParentWindow;
	import view.windows.modals.login.GitHubLogin;
	
	public class GitHub implements IHostingService {
		
		private var _type			:String = HostingAccount.GITHUB;
		private var _home	 		:GHAcctView = new GHAcctView();
		private var _api 			:GitHubApi = new GitHubApi();
		private var _key 			:GitHubKey = new GitHubKey();		
		private var _login			:GitHubLogin = new GitHubLogin();
		
		private var _addRepoObj		:Object = {	title	:	'Add To Github', 
												option	:	'Make Repository Private'	};				
		
		public function get type()			:String				{ return _type; 		}
		public function get api()			:ApiProxy 			{ return _api; 			}
		public function get key()			:KeyProxy 			{ return _key;			}
		public function get home()			:AccountBase		{ return _home; 		}
		public function get login()			:ParentWindow 		{ return _login; 		}
		public function get addRepoObj()	:Object				{ return _addRepoObj; 	}			
		
	}
	
}
