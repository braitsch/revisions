package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.GitHubApiProxy;
	import model.proxies.GitHubKeyProxy;
	import model.vo.Remote;
	import flash.events.EventDispatcher;
	
	public class GitHubManager extends EventDispatcher {

		private static var _primary		:RemoteAccount;
		private static var _api			:GitHubApiProxy = AppModel.proxies.githubApi;
		private static var _key			:GitHubKeyProxy = AppModel.proxies.githubKey;
		private static var _loggedIn	:RemoteAccount;
		private static var _accounts	:Vector.<RemoteAccount> = new Vector.<RemoteAccount>();

		public function GitHubManager()
		{
			_api.addEventListener(AppEvent.LOGOUT, onLogoutSuccess);
			_api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_key.addEventListener(AppEvent.REMOTE_KEY_VALIDATED, onPrimaryAccount);
		}

		public function addAccount(a:RemoteAccount):void
		{
			_accounts.push(a);
			if (a.primary == 1) _key.validateKeyAgainstAccount(a);
		}
	
		public function get primary():RemoteAccount
		{
			return _primary;
		}	
		
		public function get loggedIn():RemoteAccount
		{
			return _loggedIn;
		}			
		
		public function set primary(a:RemoteAccount):void
		{
			_key.changePrimaryAccount(_primary, a);
		}
		
		public function getRemoteURL(r:Remote):String
		{
			if (r.url.indexOf('git@github.com:'+_primary.user) != -1) return r.url;
			for (var i:int = 0; i < _accounts.length; i++) {
				var u:String = _accounts[i].user;
				if (r.url.indexOf('git@github.com:'+u) != -1){
					return buildHTTP(r.url, _accounts[i]);
				}	else if (r.url.indexOf('https://'+u) != -1){
					return buildHTTP(r.url, _accounts[i]);
				}
			}
			return null;
		}

		private function buildHTTP(u:String, a:RemoteAccount):String
		{
			var r:String = u.substr(u.lastIndexOf('/'));
			return 'https://'+a.user+':'+a.pass+'@github.com/'+a.user+r;
		}
//git@braitsch.beanstalkapp.com:/testing.git
//git@github.com:braitsch/Revisions-Source.git
//https://braitsch@github.com/braitsch/Revisions-Source.git
		
		private function onLoginSuccess(e:AppEvent):void
		{
			var a:RemoteAccount = e.data as RemoteAccount;
			if (checkAccountAlreadyExists(a) == false){
				_loggedIn = a;
				_accounts.push(a);
				if (!_primary) _key.validateKeyAgainstAccount(a);
				AppModel.database.addAccount(a);
			}
		}
		
		private function onLogoutSuccess(e:AppEvent):void
		{
			_loggedIn = null;
		}		
		
		private function checkAccountAlreadyExists(a:RemoteAccount):Boolean
		{
			for (var i:int = 0; i < _accounts.length; i++) if (_accounts[i].type == a.type && _accounts[i].user == a.user) return true;
			return false;
		}
		
		private function onPrimaryAccount(e:AppEvent):void
		{
			_primary = e.data as RemoteAccount;
			AppModel.database.setPrimaryAccount(_primary);
			trace("GitHubManager.onPrimaryAccount(e)", _primary.user, _primary.pass);
		}

	}
	
}
