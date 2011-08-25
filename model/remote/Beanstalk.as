package model.remote {

	import events.AppEvent;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.BeanstalkApi;
	import model.proxies.remote.keys.BeanstalkKey;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.login.AccountLogin;
	import view.modals.login.BeanstalkLogin;
	import view.modals.remote.AccountHome;
	import view.modals.remote.BeanstalkHome;
	
	public class Beanstalk extends HostingProvider {

		private static var _type		:String = HostingAccount.BEANSTALK;
		private static var _api 		:BeanstalkApi = new BeanstalkApi();
		private static var _key 		:BeanstalkKey = new BeanstalkKey();
		private static var _home 		:BeanstalkHome = new BeanstalkHome(_api);
		private static var _login		:BeanstalkLogin = new BeanstalkLogin();
		
		private static var _addRepoObj	:Object = {	title	:	'Add To Beanstalk'	};															

		public function Beanstalk()
		{
			super(_key);
			_api.addEventListener(AppEvent.LOGIN_SUCCESS, super.onLoginSuccess);
			_api.addEventListener(AppEvent.LOGOUT_SUCCESS, super.onLogoutSuccess);			
		}

		override public function get type():String { return _type; }
		
		override public function get home():AccountHome { return _home; }
		
		override public function get login():AccountLogin { return _login; }

		override public function get api():ApiProxy { return _api; }
		
		override public function get key():KeyProxy { return _key; }

		override public function get addRepoObj():Object { return _addRepoObj; }		
		
	}
	
}
