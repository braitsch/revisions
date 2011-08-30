package model.remote {

	public class Hosts {
		
		private static var _github			:HostingProvider = new HostingProvider(new GitHub());
		private static var _beanstalk		:HostingProvider = new HostingProvider(new Beanstalk());
		
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

		public static function get github():HostingProvider
		{
			return _github;
		}
		
		public static function get beanstalk():HostingProvider
		{
			return _beanstalk;
		}
		
		public static function getAccountByName(type:String, name:String):HostingAccount	
		{
			var am:HostingProvider;
			if (type == HostingAccount.GITHUB){
				am = _github;
			}	else if (type == HostingAccount.BEANSTALK){
				am = _beanstalk;
			}
			return am.getAccountByProp('user', name);
		}
		
	}
	
}
