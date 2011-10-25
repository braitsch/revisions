package model.remote {

	import events.AppEvent;
	import flash.events.EventDispatcher;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.KeyProxy;
	import view.windows.account.AccountHome;
	import view.windows.base.ParentWindow;
	
	public class HostingService extends EventDispatcher {

		private var _model					:IHostingService;
		private var _account				:HostingAccount;
		private var _loggedIn				:Boolean;

		public function get type()			:String				{ return _model.type; 			}
		public function get api()			:ApiProxy 			{ return _model.api; 			}
		public function get key()			:KeyProxy 			{ return _model.key;			}
		public function get home()			:AccountHome		{ return _model.home; 			}
		public function get login()			:ParentWindow 		{ return _model.login; 			}
		public function get addRepoObj()	:Object				{ return _model.addRepoObj; 	}

		public function HostingService(o:IHostingService):void
		{
			_model = o;
			_model.key.addEventListener(AppEvent.REMOTE_KEY_READY, onRemoteKeyReady);
		}
		
		public function set savedAccount(a:HostingAccount):void
		{
			_account = a;	
			trace("HostingService.savedAccount(a)", a.acctType, a.user);
		}
		
		public function set account(a:HostingAccount):void
		{
			if (_model.type == HostingAccount.BEANSTALK) {
				_model.key.checkKey(a);
			}	else{
				writeAcctToDatabase(a);
			}
			_loggedIn = true;
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
			_model.api.login(a);
		}
		
		public function addKeyToAccount(a:HostingAccount):void
		{
			_model.key.checkKey(a);
		}
		
		public function logOut():void
		{
			_loggedIn = false;
		}
		
		public function writeAcctToDatabase(n:HostingAccount):void
		{
			if (_account == null){
				AppModel.database.addAccount(n);
			}	else{
				AppModel.database.editAccount(n);
			}
			_account = n;
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.LOGIN_SUCCESS);			
		}
		
		private function onRemoteKeyReady(e:AppEvent):void 
		{
			writeAcctToDatabase(e.data as HostingAccount);
		}

	}
	
}
