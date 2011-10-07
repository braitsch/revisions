package model.remote {

	import events.AppEvent;
	import flash.events.EventDispatcher;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.KeyProxy;
	import view.windows.account.AccountHome;
	import view.windows.base.ParentWindow;
	
	public class HostingProvider extends EventDispatcher {

		private var _model					:IHostingProvider;
		private var _loggedIn				:HostingAccount;
		private var _saveAccount			:Boolean;
		private var _accounts				:Vector.<HostingAccount> = new Vector.<HostingAccount>();

		public function get type()			:String				{ return _model.type; 			}
		public function get api()			:ApiProxy 			{ return _model.api; 			}
		public function get key()			:KeyProxy 			{ return _model.key;			}
		public function get home()			:AccountHome		{ return _model.home; 			}
		public function get login()			:ParentWindow 		{ return _model.login; 			}
		public function get addRepoObj()	:Object				{ return _model.addRepoObj; 	}

		public function HostingProvider(o:IHostingProvider):void
		{
			_model = o;
			_model.key.addEventListener(AppEvent.REMOTE_KEY_READY, onRemoteKeyReady);
		}
		
		public function logOut():void { _loggedIn = null; }
		public function get loggedIn():HostingAccount { return _loggedIn; }		

		public function addAccount(a:HostingAccount):void
		{
			_accounts.push(a);
		}
		
		public function attemptLogin(a:HostingAccount, b:Boolean):void
		{
			_model.api.login(a); _saveAccount = b;
		}
		
		public function addKeyToAccount(a:HostingAccount, b:Boolean):void
		{
			_model.key.checkKey(a); _saveAccount = b;
		}
		
		public function getAccountByProp(p:String, v:String):HostingAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i][p] == v) return _accounts[i];
			return null;
		}
		
		public function set loggedIn(a:HostingAccount):void
		{
			_loggedIn = a;
			if (_saveAccount) writeAcctToDatabase(_loggedIn);
			if (_model.type == HostingAccount.BEANSTALK) _model.key.checkKey(_loggedIn);
		}
		
	// private methods //
	
		public function writeAcctToDatabase(n:HostingAccount):void
		{
			var o:HostingAccount = getAccountByProp('user', n.user);
			if (o == null){
				addAccount(n);
				AppModel.database.addAccount(n);
			}	else{
				swapAccounts(n, o);
				AppModel.database.editAccount(n);
			}
		}
		
		private function onRemoteKeyReady(e:AppEvent):void 
		{
			if (_saveAccount) writeAcctToDatabase(e.data as HostingAccount); 
		}
		
		private function swapAccounts(n:HostingAccount, o:HostingAccount):void
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == o) break;
			_accounts.splice(i, 1); _accounts.push(n);
		}
		
	}
	
}
