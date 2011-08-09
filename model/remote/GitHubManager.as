package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.GitHubApiProxy;
	import flash.events.EventDispatcher;
	public class GitHubManager extends EventDispatcher {

		private static var _active		:RemoteAccount;
		private static var _primary		:RemoteAccount;
		private static var _proxy		:GitHubApiProxy = AppModel.proxies.githubApi;
		private static var _accounts	:Vector.<RemoteAccount> = new Vector.<RemoteAccount>();

		public function GitHubManager()
		{
			_proxy.addEventListener(AppEvent.LOGIN, onLoginSuccess);
		}
		
		public function getLastLoggedInAccount():void
		{
			_proxy.getLastLoggedInAccount();
		}

		public function addAccount(a:RemoteAccount):void
		{
			_accounts.push(a);
			if (a.main == 1) _primary = a;
		}
		
		public function get primary():RemoteAccount
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].main == 1) return _accounts[i];
			return null;
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			var a:RemoteAccount = e.data as RemoteAccount;
			var m:Boolean;
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i] == a) m = true;
			if (m == false) addAccount(a);
			_active = a;
		}

	}
	
}
