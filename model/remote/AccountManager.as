package model.remote {

	public class AccountManager {
		
		private static var _accounts:Vector.<RemoteAccount>;
		
		public static function addAccount(ra:RemoteAccount):void
		{
			if (_accounts == null) _accounts = new Vector.<RemoteAccount>();
			_accounts.push(ra);
		}
		
	}
	
}
