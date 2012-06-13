package model.remote {
	import events.AppEvent;

	public class Hosts {
		
		private static var _github			:HostingService = new HostingService(new GitHub());
		private static var _beanstalk		:HostingService = new HostingService(new Beanstalk());
		
		public static function initialize(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				if (a[i].type == HostingAccount.GITHUB){
					_github.account = new HostingAccount(a[i]);
				}	else if (a[i].type == HostingAccount.BEANSTALK){
					_beanstalk.account = new HostingAccount(a[i]);
				}		
			}
			attemptAutoLogin();
		}

		public static function get github():HostingService
		{
			return _github;
		}
		
		public static function get beanstalk():HostingService
		{
			return _beanstalk;
		}
		
		private static function attemptAutoLogin():void
		{
			if (_github.account){
				_github.attemptAutoLogin();
				_github.api.addEventListener(AppEvent.LOGIN_SUCCESS, attemptBeanstalkLogin);
				_github.api.addEventListener(AppEvent.LOGIN_FAILURE, attemptBeanstalkLogin);
			}	else if (_beanstalk.account){
				_beanstalk.attemptAutoLogin();
			}
		}

		private static function attemptBeanstalkLogin(e:AppEvent):void
		{
			if (_beanstalk.account) _beanstalk.attemptAutoLogin();
			_github.api.removeEventListener(AppEvent.LOGIN_SUCCESS, attemptBeanstalkLogin);
			_github.api.removeEventListener(AppEvent.LOGIN_FAILURE, attemptBeanstalkLogin);			
		}
		
	}
	
}
