package model.remote {

	import model.proxies.remote.acct.BeanstalkApi;
	import model.proxies.remote.keys.BeanstalkKey;
	import view.modals.login.BeanstalkLogin;
	import view.modals.remote.BeanstalkHome;
	
	public class Beanstalk {

		public var type			:String = HostingAccount.BEANSTALK;
		public var api 			:BeanstalkApi = new BeanstalkApi();
		public var key 			:BeanstalkKey = new BeanstalkKey();
		public var home	 		:BeanstalkHome = new BeanstalkHome();
		public var login		:BeanstalkLogin = new BeanstalkLogin();
		
		public var addRepoObj	:Object = {	title	:	'Add To Beanstalk'	};															

	}
	
}
