package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.LoginProxy;
	import flash.events.EventDispatcher;
	
	public class AccountManager extends EventDispatcher {

		private var _login			:LoginProxy = AppModel.proxies.ghLogin;
		private var _loggedIn		:Boolean;
		private var _accounts		:Vector.<RemoteAccount> = new Vector.<RemoteAccount>();

		public function AccountManager(type:String)
		{
			if (type == RemoteAccount.BEANSTALK) return;
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_login.addEventListener(AppEvent.REMOTE_KEY_SET, onPrimaryAccountSet);
		}
		
		public function addAccount(a:RemoteAccount):void
		{
			_accounts.push(a);
		}
	
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}	
		
		public function set loggedIn(b:Boolean):void
		{
			_loggedIn = b;
			if (b == false) dispatchLoggedOutAlert();
		}				
		
		public function getAccountByName(n:String):RemoteAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].user == n) return _accounts[i];
			return null;
		}
		
	// private methods //	
		
		private function onLoginSuccess(e:AppEvent):void
		{
			var a:RemoteAccount = e.data as RemoteAccount;
			var b:RemoteAccount = checkAccountAlreadyExists(a);
			if (b == null){
				addAccount(a);
				AppModel.database.addAccount(a);
			}	else{
				b = a;
				AppModel.database.editAccount(a);
			}
			_loggedIn = true;
			setPrimaryAccount();
		}
		
		private function checkAccountAlreadyExists(a:RemoteAccount):RemoteAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].type == a.type && _accounts[i].user == a.user) return _accounts[i];
			return null;
		}
		
		private function setPrimaryAccount():void
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].sshKeyId != 0) return;
			_login.setPrimaryAccount(_accounts[0]);
		}
		
		private function onPrimaryAccountSet(e:AppEvent):void
		{
			AppModel.database.setSSHKeyId(e.data as RemoteAccount);
		}		
		
		private function dispatchLoggedOutAlert():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));				
		}
		
//git@braitsch.beanstalkapp.com:/testing.git
//git@github.com:braitsch/Revisions-Source.git
//https://braitsch@github.com/braitsch/Revisions-Source.git
		

	}
	
}
