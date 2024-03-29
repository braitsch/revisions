package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.KeyProxy;
	import view.windows.account.base.AccountBase;
	import view.windows.base.ParentWindow;
	import flash.events.EventDispatcher;
	
	public class HostingService extends EventDispatcher {

		private var _model					:IHostingService;
		private var _account				:HostingAccount;
		private var _loggedIn				:Boolean;

		public function get type()			:String				{ return _model.type; 			}
		public function get api()			:ApiProxy 			{ return _model.api; 			}
		public function get key()			:KeyProxy 			{ return _model.key;			}
		public function get home()			:AccountBase		{ return _model.home; 			}
		public function get login()			:ParentWindow 		{ return _model.login; 			}
		public function get addRepoObj()	:Object				{ return _model.addRepoObj; 	}

		public function HostingService(o:IHostingService):void
		{
			_model = o;
			_model.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_model.api.addEventListener(AppEvent.LOGIN_FAILURE, onLoginFailure);
			_model.key.addEventListener(AppEvent.REMOTE_KEY_READY, onRemoteKeyReady);
		}

		public function set account(a:HostingAccount):void
		{
			_account = a;	
		}
		
		public function get account():HostingAccount 
		{ 
			return _account; 
		}
		
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}				
		
		public function attemptLogin(a:HostingAccount):void
		{
			_model.api.login(a, false);
		}
		
		public function attemptAutoLogin():void
		{
			_model.api.login(_account, true);	
		}
		
		public function addKeyToAccount():void
		{
			_model.key.checkKey(_account);
		}
		
		public function logOut():void
		{
			_loggedIn = false;
		}
		
		private function writeAcctToDatabase(n:HostingAccount):void
		{
			if (_account == null){
				AppModel.database.addAccount(n);
			}	else{
				AppModel.database.editAccount(n);
			}
			_account = n;
			_model.home.account = _account;
			AppModel.dispatch(AppEvent.LOGIN_SUCCESS);
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			if (_model.type == HostingAccount.BEANSTALK) {
				_model.key.checkKey(e.data as HostingAccount);
			}	else{
				writeAcctToDatabase(e.data as HostingAccount);
			}
			_loggedIn = true;
		}
		
		private function onLoginFailure(e:AppEvent):void
		{
			AppModel.database.deleteAccount(_account); _account == null;			
		}				
		
		private function onRemoteKeyReady(e:AppEvent):void 
		{
			writeAcctToDatabase(e.data as HostingAccount);
		}

		public function setUserAndPass(u:String, p:String):void
		{
			_account.setUserAndPass(u, p);
			writeAcctToDatabase(_account);
		}

	}
	
}
