package model.remote {

	import events.AppEvent;
	import model.proxies.remote.BeanstalkProxy;
	import model.proxies.remote.KeyProxy;
	import view.modals.login.BeanstalkLogin;
	import view.modals.remote.AddBkmkToBeanstalk;
	import view.modals.remote.GitHubHome;
	
	public class Beanstalk {

		private static var _key 		:KeyProxy = new KeyProxy();
		private static var _user 		:BeanstalkProxy = new BeanstalkProxy();
		private static var _home 		:GitHubHome	= new GitHubHome(_user);
		private static var _login 		:BeanstalkLogin = new BeanstalkLogin();
		private static var _addRepo		:AddBkmkToBeanstalk = new AddBkmkToBeanstalk(_user);

		public function Beanstalk()
		{
			_login.addEventListener(AppEvent.ATTEMPT_LOGIN, attemptLogin);			
		}
		
		private function attemptLogin(e:AppEvent):void
		{
			e.data.type = RemoteAccount.BEANSTALK;
			_user.login(new RemoteAccount(e.data));
		}		
		
		public function get key():KeyProxy
		{
			return _key;
		}

		public function get user():BeanstalkProxy
		{
			return _user;
		}

		public function get home():GitHubHome
		{
			return _home;
		}

		public function get login():BeanstalkLogin
		{
			return _login;
		}

		public function get addRepo():AddBkmkToBeanstalk
		{
			return _addRepo;
		}
		
	}
	
}
