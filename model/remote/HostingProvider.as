package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.login.AccountLogin;
	import view.modals.remote.AccountHome;
	import flash.events.EventDispatcher;
	
	public class HostingProvider extends EventDispatcher {

		private var _model					:IHostingProvider;
		private var _loggedIn				:HostingAccount;
		private var _accounts				:Vector.<HostingAccount> = new Vector.<HostingAccount>();

		public function get type()			:String				{ return _model.type; 			}
		public function get api()			:ApiProxy 			{ return _model.api; 			}
		public function get key()			:KeyProxy 			{ return _model.key;			}
		public function get home()			:AccountHome		{ return _model.home; 			}
		public function get login()			:AccountLogin 		{ return _model.login; 			}
		public function get addRepoObj()	:Object				{ return _model.addRepoObj; 	}

		public function HostingProvider(o:IHostingProvider):void{
			_model = o;
			_model.login.addEventListener(AppEvent.LOGIN, onLoginClick);
			_model.home.addEventListener(AppEvent.LOGOUT, onLogoutClick);
			_model.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);			
		}
		
		public function get loggedIn():HostingAccount
		{
			return _loggedIn;
		}		

		public function addAccount(a:HostingAccount):void
		{
			_accounts.push(a);
		}
		
		public function getAccountByProp(p:String, v:String):HostingAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i][p] == v) return _accounts[i];
			return null;
		}
		
	// private methods //	
		
		private function onLoginClick(e:AppEvent):void
		{
			_model.api.login(e.data as HostingAccount);
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			_loggedIn = e.data as HostingAccount;
			_model.home.model = _loggedIn;
			_model.login.dispatchLoginSuccessEvent();
			saveAccount(); 
			if (_model.type == HostingAccount.BEANSTALK) _model.key.checkKey(_loggedIn);
		}
		
		private function onLogoutClick(e:AppEvent):void
		{
			_loggedIn = null;
		}			
		
	// private methods //
	
		private function saveAccount():void
		{
		// if user checked "remember this account" in the login window //	
			var b:HostingAccount = getAccountByProp('user', _loggedIn.user);
			if (b == null){
				addAccount(_loggedIn);
				AppModel.database.addAccount(_loggedIn);
			}	else{
				AppModel.database.editAccount(_loggedIn);
			}
		}
		
		
//		private function swapAccounts(a:HostingAccount, b:HostingAccount):void
//		{
//			a.sshKeyId = b.sshKeyId;
//			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == b) break;
//			_accounts.splice(i, 1); _accounts.push(a);
//		}
		
	}
	
}
