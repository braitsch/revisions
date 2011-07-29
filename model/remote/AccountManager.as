package model.remote {

	import model.AppModel;
	public class AccountManager {
				
		private static var _accounts		:Vector.<RemoteAccount>;
		
		public static function initialize():void
		{
			AppModel.proxies.githubApi.getAccountInfo();
		}

		public static function addAccount(ra:RemoteAccount):void
		{
			if (_accounts == null) _accounts = new Vector.<RemoteAccount>();
			_accounts.push(ra);
		}
		
		public static function killAccount(ra:RemoteAccount):void
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == ra) _accounts.splice(i, 1);
		}		

		public static function get github():RemoteAccount
		{
			return getAccount(RemoteAccount.GITHUB);
		}
		
		public static function get beanstalk():RemoteAccount
		{
			return getAccount(RemoteAccount.BEANSTALK);
		}		
		
		private static function getAccount(s:String):RemoteAccount
		{
			if (_accounts) for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].type == s) return _accounts[i];
			return null;
		}

	}
	
}
