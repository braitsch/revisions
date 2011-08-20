package model.proxies.remote.acct {

	import events.AppEvent;
	import model.proxies.remote.RemoteProxy;
	import model.remote.Account;
	import system.BashMethods;

	public class AccountProxy extends RemoteProxy {

		private static var _baseURL		:String;
		private static var _account		:Account;

		public function AccountProxy()
		{
			super.executable = 'Account.sh';
		}
		
		protected function get account()				:Account 	{ return _account; 		}
		protected function set baseURL(baseURL:String)	:void 		{ _baseURL = baseURL; 	}	

		public function login(ra:Account):void { _account = ra; }
		
		public function logout():void
		{
			super.request = BashMethods.LOGOUT;
			dispatchEvent(new AppEvent(AppEvent.LOGOUT_SUCCESS));
		}
		
		public function makeNewAccountRepo(name:String, desc:String, publik:Boolean):void
		{
			super.call(Vector.<String>([BashMethods.ADD_BKMK_TO_ACCOUNT, name, desc, publik]));
		}
		
		protected function attemptLogin(url:String):void
		{
			startTimer();
			super.request = BashMethods.LOGIN;
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));
		}		
		
		protected function getRepositories(url:String):void
		{
			startTimer();
			super.request = BashMethods.GET_REPOSITORIES;
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));
		}												
		
		override protected function onProcessSuccess(r:String):void
		{
			switch(super.request){
				case BashMethods.LOGIN :
					onLoginSuccess(r);
				break;
				case BashMethods.GET_REPOSITORIES :
					onRepositories(r);
				break;
				case BashMethods.ADD_BKMK_TO_ACCOUNT : 
					onRepositoryCreated(r);
				break;									
			}			
		}
		
	// callbacks //	
		
		protected function onLoginSuccess(s:String):void { }
		
		protected function onRepositories(s:String):void { }
		
		protected function onRepositoryCreated(s:String):void { }
		
		protected function dispatchLoginSuccess():void { dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account)); }
		
	}
	
}
