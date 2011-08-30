package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.login.AccountLogin;
	import view.modals.remote.AccountHome;
	import flash.events.EventDispatcher;
	
	public class HostingProvider extends EventDispatcher {

		private var _model					:Object;
		private var _loggedIn				:Boolean;
		private var _accounts				:Vector.<HostingAccount> = new Vector.<HostingAccount>();

		public function get type()			:String				{ return _model.type; 			}
		public function get home()			:AccountHome		{ return _model.home; 			}
		public function get login()			:AccountLogin 		{ return _model.login; 			}
		public function get api()			:ApiProxy 			{ return _model.api; 			}
		public function get key()			:KeyProxy 			{ return _model.key;			}
		public function get addRepoObj()	:Object				{ return _model.addRepoObj; 	}

		public function HostingProvider(o:Object):void{
			_model = o;
			_model.login.addEventListener(AppEvent.LOGIN, onLoginClick);
			_model.home.addEventListener(AppEvent.LOGOUT, onLogoutClick);
			_model.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);			
		}
		
		public function get loggedIn():Boolean
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
			api.login(e.data as HostingAccount);
		}

		private function onLogoutClick(e:AppEvent):void
		{
			_loggedIn = false;
			home.closeWindow();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			_loggedIn = true;
		// if user checked "remember this account"	
			cacheAccount(e.data as HostingAccount);
			validateKey();
			login.dispatchLoginSuccessEvent();
			home.model = e.data as HostingAccount;
		}		
		
	// private methods //
	
		private function cacheAccount(a:HostingAccount):void
		{
			var b:HostingAccount = getAccountByProp('user', a.user);
			if (b == null){
				addAccount(a);
				AppModel.database.addAccount(a);
			}	else{
				swapAccounts(a, b);
				AppModel.database.editAccount(a);
			}
//			var x:HostingAccount;
//			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].sshKeyId != 0) x = _accounts[i];
//			if (x == null || x === a) _keyProxy.validateKey(a);
		}
		
		private function validateKey():void
		{
			
		}
		
		private function swapAccounts(a:HostingAccount, b:HostingAccount):void
		{
			a.sshKeyId = b.sshKeyId;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == b) break;
			_accounts.splice(i, 1); _accounts.push(a);
		}
		
	}
	
}
