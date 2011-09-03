package model.remote {

	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.BeanstalkApi;
	import model.proxies.remote.keys.BeanstalkKey;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.account.AccountHome;
	import view.modals.account.BeanstalkHome;
	import view.modals.base.ModalWindow;
	import view.modals.login.BeanstalkLogin;
	
	public class Beanstalk implements IHostingProvider {

		private var _type			:String = HostingAccount.BEANSTALK;
		private var _api 			:BeanstalkApi = new BeanstalkApi();
		private var _key 			:BeanstalkKey = new BeanstalkKey();
		private var _home	 		:BeanstalkHome = new BeanstalkHome();
		private var _login			:BeanstalkLogin = new BeanstalkLogin();
		
		private var _addRepoObj	:Object = {	title	:	'Add To Beanstalk'	};
		
		public function get type()			:String				{ return _type; 		}
		public function get api()			:ApiProxy 			{ return _api; 			}
		public function get key()			:KeyProxy 			{ return _key;			}
		public function get home()			:AccountHome		{ return _home; 		}
		public function get login()			:ModalWindow 		{ return _login; 		}
		public function get addRepoObj()	:Object				{ return _addRepoObj; 	}															

	}
	
}
