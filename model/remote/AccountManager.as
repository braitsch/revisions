package model.remote {

	import model.AppModel;
	import model.db.AppSettings;
	public class AccountManager {
		
		private static var _accounts:Vector.<RemoteAccount>;
		
		public static function initialize():void
		{
			var gn:String = AppSettings.getSetting(AppSettings.GITHUB_USER);
			var gp:String = AppSettings.getSetting(AppSettings.GITHUB_PASS);
		//	if (gn && gp) AppModel.proxies.github.login(gn, gp);
		}		
		
		public static function addAccount(ra:RemoteAccount):void
		{
			if (_accounts == null) _accounts = new Vector.<RemoteAccount>();
			_accounts.push(ra);
			trace('AccountManager.addAccount :', ra.type, ra.name, ra.pass, ra.avatarURL);			
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
