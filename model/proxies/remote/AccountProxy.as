package model.proxies.remote {

	import model.remote.RemoteAccount;
	public class AccountProxy {
	
		private var _key		:KeyProxy = new KeyProxy();
		private var _acct		:UserProxy = new UserProxy();
		private var _repo		:RepoProxy = new RepoProxy();

		public function get key()	:KeyProxy { return _key; }
		public function get acct()	:UserProxy { return _acct; }
		public function get repo()	:RepoProxy { return _repo; }
		
		public function login(u:String, p:String):void
		{
			_acct.login(new RemoteAccount({type:RemoteAccount.GITHUB, user:u, pass:p}));
		}
		
		public function logout():void 
		{
			_acct.logout();
		}		
		
	}
	
}
