package model.remote {

	import model.proxies.remote.AccountProxy;
	import model.proxies.remote.BeanstalkProxy;
	import model.proxies.remote.KeyProxy;
	import view.modals.remote.AccountHome;
	import view.modals.remote.AddBkmkToAccount;
	import view.modals.remote.AddBkmkToBeanstalk;
	import view.modals.remote.BeanstalkHome;
	
	public class Beanstalk extends HostingProvider {

		private static var _type		:String = Account.BEANSTALK;
		private static var _proxy 		:BeanstalkProxy = new BeanstalkProxy();
		private static var _home 		:BeanstalkHome	= new BeanstalkHome(_proxy);
		private static var _addRepo		:AddBkmkToBeanstalk = new AddBkmkToBeanstalk(_proxy);
		
		private static var _loginObj	:Object = {	title	:	'Login To Beanstalk',
													button	:	new BeanStalkButton(),
													signup	:	'http://beanstalkapp.com/pricing' };		

		public function Beanstalk()
		{
			super(new KeyProxy());
		}

		override public function get type():String { return _type; }

		override public function get proxy():AccountProxy { return _proxy; }

		override public function get home():AccountHome { return _home; }

		override public function get addRepo():AddBkmkToAccount { return _addRepo; }

		override public function get loginObj():Object { return _loginObj; }
		
	}
	
}
