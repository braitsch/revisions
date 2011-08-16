package model.remote {

	import model.proxies.remote.SSHKeyProxy;
	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.AccountProxy;
	import flash.events.EventDispatcher;
	
	public class AccountManager extends EventDispatcher {

		private var _loggedIn			:Boolean;
		private var _keyProxy			:SSHKeyProxy = new SSHKeyProxy();
		private var _acctProxy			:AccountProxy = new AccountProxy();
		private var _accounts			:Vector.<RemoteAccount> = new Vector.<RemoteAccount>();

		public function AccountManager(type:String)
		{
			if (type == RemoteAccount.BEANSTALK) return;
			_keyProxy.addEventListener(AppEvent.REMOTE_KEY_SET, onKeyValidated);
			_acctProxy.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_acctProxy.addEventListener(AppEvent.LOGOUT_SUCCESS, onLogoutSuccess);
		}

		public function addAccount(a:RemoteAccount):void
		{
			_accounts.push(a);
		}
		
		public function login(u:String, p:String):void
		{
			_acctProxy.login(new RemoteAccount({type:RemoteAccount.GITHUB, user:u, pass:p}));
		}
		
		public function logout():void 
		{
			_acctProxy.logout();
		}		
	
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}
		
		public function getAccountByProp(p:String, v:String):RemoteAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i][p] == v) return _accounts[i];
			return null;
		}				
		
	// private methods //	
		
		private function onLoginSuccess(e:AppEvent):void
		{
			var a:RemoteAccount = e.data as RemoteAccount; // new password
			var b:RemoteAccount = getAccountByProp('user', a.user);
			if (b == null){
				addAccount(a);
				AppModel.database.addAccount(a);
			}	else{
				swapAccounts(a, b);
				AppModel.database.editAccount(a);
			}
			_loggedIn = true;
			var x:RemoteAccount;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].sshKeyId != 0) x = _accounts[i];
			if (x == null || x === a) _keyProxy.validateKey(a);	
		}
		
		private function swapAccounts(a:RemoteAccount, b:RemoteAccount):void
		{
			a.sshKeyId = b.sshKeyId;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == b) break;
			_accounts.splice(i, 1); _accounts.push(a);
		}
		
		private function onLogoutSuccess(e:AppEvent):void
		{
			_loggedIn = false;
			dispatchEvent(new AppEvent(AppEvent.LOGOUT_SUCCESS));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));			
		}
		
		private function onKeyValidated(e:AppEvent):void
		{
			AppModel.database.setSSHKeyId(e.data as RemoteAccount);
		}

//git@braitsch.beanstalkapp.com:/testing.git
//git@github.com:braitsch/Revisions-Source.git
//https://braitsch@github.com/braitsch/Revisions-Source.git
		

	}
	
}
