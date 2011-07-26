package model.remote {

	import events.AppEvent;
	import model.AppModel;
	public class AccountManager {

				
		private static var _accounts		:Vector.<RemoteAccount>;
		private static var _gitHubReady		:Boolean;
//		private static var _beanstalkReady	:Boolean;
		
		public static function initialize():void
		{
			AppModel.proxies.githubApi.getAccountInfo();
			AppModel.proxies.githubApi.addEventListener(AppEvent.GITHUB_READY, function(e:AppEvent):void{_gitHubReady = true;});
		}

		public static function addAccount(ra:RemoteAccount):void
		{
			if (_accounts == null) _accounts = new Vector.<RemoteAccount>();
			_accounts.push(ra);
		}

		public static function get github():RemoteAccount
		{
			return getAccount(RemoteAccount.GITHUB);
		}
		
		public static function get gitHubReady():Boolean
		{
			return _gitHubReady;
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
