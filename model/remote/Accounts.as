package model.remote {

	public class Accounts {
		
		private static var _github			:AccountManager = new AccountManager(new GitHub());
		private static var _beanstalk		:AccountManager = new AccountManager(new Beanstalk());
		
		public static function initialize(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				if (a[i].type == RemoteAccount.GITHUB){
					_github.addAccount(new RemoteAccount(a[i]));
				}	else if (a[i].type == RemoteAccount.BEANSTALK){
					_beanstalk.addAccount(new RemoteAccount(a[i]));
				}		
			}
		}

		public static function get github():AccountManager
		{
			return _github;
		}
		
		public static function get beanstalk():AccountManager
		{
			return _beanstalk;
		}
		
		public static function getAccountByName(type:String, name:String):RemoteAccount	
		{
			var am:AccountManager;
			if (type == RemoteAccount.GITHUB){
				am = _github;
			}	else if (type == RemoteAccount.BEANSTALK){
				am = _beanstalk;
			}
			return am.getAccountByProp('user', name);
		}
		
	}
	
}
