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

		public static function get github():*
		{
			return _github;
		}
		
		public static function get beanstalk():*
		{
			return _beanstalk;
		}		
		
	}
	
}
