package model.remote {

	public class Hosts {
		
		private static var _github			:HostingProvider = new GitHub();
		private static var _beanstalk		:HostingProvider = new Beanstalk();
		
		public static function initialize(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				if (a[i].type == Account.GITHUB){
					_github.addAccount(new Account(a[i]));
				}	else if (a[i].type == Account.BEANSTALK){
					_beanstalk.addAccount(new Account(a[i]));
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
		
		public static function getAccountByName(type:String, name:String):Account	
		{
			var am:HostingProvider;
			if (type == Account.GITHUB){
				am = _github;
			}	else if (type == Account.BEANSTALK){
				am = _beanstalk;
			}
			return am.getAccountByProp('user', name);
		}
		
	}
	
}
