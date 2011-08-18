package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import view.modals.login.BaseAccountLogin;
	import view.modals.remote.AccountHome;
	import view.modals.remote.AddBkmkToAccount;
	import flash.events.EventDispatcher;
	
	public class HostingProvider extends EventDispatcher {

		private var _model				:Object;
		private var _loggedIn			:Boolean;
		private var _accounts			:Vector.<Account> = new Vector.<Account>();

		public function get home()		:AccountHome		{ return _model.home; 	}
		public function get login()		:BaseAccountLogin	{ return _model.login; 	}
		public function get addRepo()	:AddBkmkToAccount	{ return _model.addRepo;}

		public function HostingProvider(m:Object)
		{
			_model = m;
			_model.user.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_model.user.addEventListener(AppEvent.LOGOUT_SUCCESS, onLogoutSuccess);			
		}
		
		public function addAccount(a:Account):void
		{
			_accounts.push(a);
		}
		
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}
		
		public function getAccountByProp(p:String, v:String):Account
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i][p] == v) return _accounts[i];
			return null;
		}
		
	// private methods //
	
		protected function onLoginSuccess(e:AppEvent):void
		{
			var a:Account = e.data as Account; // new password
			var b:Account = getAccountByProp('user', a.user);
			if (b == null){
				addAccount(a);
				AppModel.database.addAccount(a);
			}	else{
				swapAccounts(a, b);
				AppModel.database.editAccount(a);
			}
			_loggedIn = true;
			var x:Account;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].sshKeyId != 0) x = _accounts[i];
			if (x == null || x === a) _model.key.validateKey(a);
		}
		
		private function swapAccounts(a:Account, b:Account):void
		{
			a.sshKeyId = b.sshKeyId;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == b) break;
			_accounts.splice(i, 1); _accounts.push(a);
		}
		
		protected function onLogoutSuccess(e:AppEvent):void
		{
			_loggedIn = false;
			dispatchEvent(new AppEvent(AppEvent.LOGOUT_SUCCESS));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));			
		}
		
//git@braitsch.beanstalkapp.com:/testing.git
//git@github.com:braitsch/Revisions-Source.git
//https://braitsch@github.com/braitsch/Revisions-Source.git
		

	}
	
}
