package model.remote {

	public class Hosts {
		
		private static var _github			:HostingService = new HostingService(new GitHub());
		private static var _beanstalk		:HostingService = new HostingService(new Beanstalk());
		
		public static function initialize(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				if (a[i].type == HostingAccount.GITHUB){
					_github.addAccount(new HostingAccount(a[i]));
				}	else if (a[i].type == HostingAccount.BEANSTALK){
					_beanstalk.addAccount(new HostingAccount(a[i]));
				}		
			}
		}

		public static function get github():HostingService
		{
			return _github;
		}
		
		public static function get beanstalk():HostingService
		{
			return _beanstalk;
		}
		
		public static function getAccountByName(type:String, name:String):HostingAccount	
		{
			var am:HostingService;
			if (type == HostingAccount.GITHUB){
				am = _github;
			}	else if (type == HostingAccount.BEANSTALK){
				am = _beanstalk;
			}
			return am.getAccountByProp('user', name);
		}
		
	}
	
}
