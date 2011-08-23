package model.remote {

	import events.AppEvent;
	import model.proxies.remote.acct.AccountProxy;
	import model.proxies.remote.acct.BeanstalkProxy;
	import model.proxies.remote.keys.BSKeyProxy;
	import view.modals.remote.AccountHome;
	import view.modals.remote.BeanstalkHome;
	
	public class Beanstalk extends HostingProvider {

		private static var _type		:String = HostingAccount.BEANSTALK;
		private static var _proxy 		:BeanstalkProxy = new BeanstalkProxy();
		private static var _home 		:BeanstalkHome	= new BeanstalkHome(_proxy);
		
		private static var _loginObj	:Object = {	title	:	'Login To Beanstalk',
													button	:	new BeanStalkButton(),
													signup	:	'http://beanstalkapp.com/pricing' };
													
		private static var _addRepoObj	:Object = {	title	:	'Add To Beanstalk'	};															

		public function Beanstalk()
		{
			super(new BSKeyProxy());
			_proxy.addEventListener(AppEvent.LOGIN_SUCCESS, super.onLoginSuccess);
			_proxy.addEventListener(AppEvent.LOGOUT_SUCCESS, super.onLogoutSuccess);			
		}

		override public function get type():String { return _type; }
		
		override public function get home():AccountHome { return _home; }

		override public function get proxy():AccountProxy { return _proxy; }

		override public function get loginObj():Object { return _loginObj; }
		
		override public function get addRepoObj():Object { return _addRepoObj; }		
		
	}
	
}
