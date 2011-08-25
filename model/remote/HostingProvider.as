package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.login.AccountLogin;
	import view.modals.remote.AccountHome;
	import flash.events.EventDispatcher;
	
	public class HostingProvider extends EventDispatcher {

		private var _keyProxy				:KeyProxy;
		private var _loggedIn				:Boolean;
		private var _accounts				:Vector.<HostingAccount> = new Vector.<HostingAccount>();

		public function get type()			:String				{ return null; 	}
		public function get home()			:AccountHome		{ return null; 	}
		public function get login()			:AccountLogin 		{ return null;  }
		public function get api()			:ApiProxy 			{ return null; 	}
		public function get key()			:KeyProxy 			{ return null; 	}
		public function get addRepoObj()	:Object				{ return null; 	}

		public function HostingProvider(kp:KeyProxy)
		{
			_keyProxy = kp;
		}

		public function addAccount(a:HostingAccount):void
		{
			_accounts.push(a);
		}
		
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}
		
		public function getAccountByProp(p:String, v:String):HostingAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i][p] == v) return _accounts[i];
			return null;
		}
		
	// private methods //
	
		protected function onLoginSuccess(e:AppEvent):void
		{
			var a:HostingAccount = e.data as HostingAccount; // new password
			var b:HostingAccount = getAccountByProp('user', a.user);
			if (b == null){
				addAccount(a);
				AppModel.database.addAccount(a);
			}	else{
				swapAccounts(a, b);
				AppModel.database.editAccount(a);
			}
			_loggedIn = true;
			var x:HostingAccount;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].sshKeyId != 0) x = _accounts[i];
			if (x == null || x === a) _keyProxy.validateKey(a);
		}
		
		private function swapAccounts(a:HostingAccount, b:HostingAccount):void
		{
			a.sshKeyId = b.sshKeyId;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == b) break;
			_accounts.splice(i, 1); _accounts.push(a);
		}
		
		protected function onLogoutSuccess(e:AppEvent):void
		{
			_loggedIn = false;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));			
		}
		
	}
	
}
