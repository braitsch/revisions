package model.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.GitHubApiProxy;
	import model.proxies.GitHubKeyProxy;
	import model.vo.Remote;
	import flash.events.EventDispatcher;
	
	public class GitHubManager extends EventDispatcher {

		private static var _api			:GitHubApiProxy = AppModel.proxies.githubApi;
		private static var _key			:GitHubKeyProxy = AppModel.proxies.githubKey;
		private static var _loggedIn	:Boolean;
		private static var _primary		:RemoteAccount;
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
	
		public function get loggedIn():Boolean
		{
			return _loggedIn;
		}			
		
		public function set primary(a:RemoteAccount):void
		{
			_key.changePrimaryAccount(_primary, a);
		}
		
	// private methods //	
		
		private function onLoginSuccess(e:AppEvent):void
		{
			var a:RemoteAccount = e.data as RemoteAccount;
			if (checkAccountAlreadyExists(a) == false){
				_accounts.push(a);
				if (!_primary) _key.validateKeyAgainstAccount(a);
				AppModel.database.addAccount(a);
			}
			_loggedIn = true;
		}
		
		private function onLogoutSuccess(e:AppEvent):void
		{
			_loggedIn = false;
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

		public function getRemoteURL(r:Remote):String
		{
			if (isInPrimaryAccount(r.url)) {
				return r.url;
			}	else{
				return getHttpsURL(r.url);
			}
			return null;
		}
		
		public function getHttpsURL(url:String):String
		{
			for (var i:int = 0; i < _accounts.length; i++) {
				var usr:String = _accounts[i].user;
				if (url.indexOf('git@github.com:'+usr) != -1){
					return buildHttpsURL(url, _accounts[i]);
				}	else if (url.indexOf('https://'+usr) != -1){
					return buildHttpsURL(url, _accounts[i]);
				}
			}
			return null;
		}
		
		private function isInPrimaryAccount(url:String):Boolean
		{
			if (_primary == null) {
				return false;
			}	else{
				return (url.indexOf('git@github.com:'+_primary.user) != -1);
			}
		}		
		
		private function buildHttpsURL(u:String, a:RemoteAccount):String
		{
			var r:String = u.substr(u.lastIndexOf('/'));
			return 'https://'+a.user+':'+a.pass+'@github.com/'+a.user+r;
		}
		
//git@braitsch.beanstalkapp.com:/testing.git
//git@github.com:braitsch/Revisions-Source.git
//https://braitsch@github.com/braitsch/Revisions-Source.git
		

	}
	
}
