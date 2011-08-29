package model.remote {

	import events.AppEvent;
	import model.AppModel;
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
		private static var _home 		:BeanstalkHome = new BeanstalkHome();
		private static var _login		:BeanstalkLogin = new BeanstalkLogin();
		
		private static var _addRepoObj	:Object = {	title	:	'Add To Beanstalk'	};															

		public function Beanstalk()
		{
			_login.addEventListener(AppEvent.LOGIN, onLoginClick);
			_home.addEventListener(AppEvent.LOGOUT, onLogoutClick);
			_api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}
		
		private function onLoginClick(e:AppEvent):void
		{
			_api.login(e.data as HostingAccount);
		}

		private function onLogoutClick(e:AppEvent):void
		{
			super.loggedIn = false;
			_home.closeWindow();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			super.loggedIn = true;
			super.cacheAccount(e.data as HostingAccount);
			_login.dispatchLoginSuccessEvent();
			_home.model = e.data as HostingAccount;
		}
		
		override public function get type():String { return _type; }
		
		override public function get home():AccountHome { return _home; }
		
		override public function get login():AccountLogin { return _login; }

		override public function get api():ApiProxy { return _api; }
		
		override public function get key():KeyProxy { return _key; }
		
		override public function get addRepoObj():Object { return _addRepoObj; }		
		
	}
	
}
