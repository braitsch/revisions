package model.remote {

	public class Accounts {
		
		private static var _github			:GitHubManager = new GitHubManager();
		private static var _beanstalk		:BeanstalkManager = new BeanstalkManager();
		
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

//		public static function killAccount(ra:RemoteAccount):void
//		{
//			for (var i:int = 0; i < _accounts.length; i++) {
//				if (_accounts[i] == ra) {
//					_accounts.splice(i, 1);
//				}
//			}
//		}

		public static function get github():RemoteAccount
		{
			return null; //getAccount(RemoteAccount.GITHUB);
		}
		
		public static function get beanstalk():RemoteAccount
		{
			return null; //getAccount(RemoteAccount.BEANSTALK);
		}		
		
//		private static function getAccount(s:String):RemoteAccount
//		{
//			if (_accounts) for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].type == s) return _accounts[i];
//			return null;
//		}

	}
	
}
