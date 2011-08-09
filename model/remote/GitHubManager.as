package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.GitHubApiProxy;
	import model.proxies.GitHubKeyProxy;
	import flash.events.EventDispatcher;
	
	public class GitHubManager extends EventDispatcher {

		private static var _primary		:RemoteAccount;
		private static var _api			:GitHubApiProxy = AppModel.proxies.githubApi;
		private static var _key			:GitHubKeyProxy = AppModel.proxies.githubKey;
		private static var _accounts	:Vector.<RemoteAccount> = new Vector.<RemoteAccount>();

		public function GitHubManager()
		{
			_api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_key.addEventListener(AppEvent.PRIMARY_ACCOUNT_SET, onPrimaryAccount);
		}

		public function addAccount(a:RemoteAccount):void
		{
			_accounts.push(a);
			if (a.primary == 1) _key.checkKeysOnPrimaryAccount(a);
		}
	
		public function get primary():RemoteAccount
		{
			return _primary;
		}	
		
		public function set primary(a:RemoteAccount):void
		{
		// write to the db, clear-primary, set-primary
			_key.changePrimaryAccount(_primary, a);
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			var a:RemoteAccount = e.data as RemoteAccount;
			if (checkAccountAlreadyExists(a) == false){
				if (!_primary) a.primary = 1;
				addAccount(a);
				AppModel.database.addAccount(a);
			}
		}
		
		private function checkAccountAlreadyExists(a:RemoteAccount):Boolean
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].type == a.type && _accounts[i].user == a.user) return true;
			return false;
		}
		
		private function onPrimaryAccount(e:AppEvent):void
		{
			_primary = e.data as RemoteAccount;
			trace("GitHubManager.onPrimaryAccount(e)", _primary.user, _primary.pass);
		}		

	}
	
}
