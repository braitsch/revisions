package model.proxies.remote.repo {

	import events.AppEvent;
	import events.ErrEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.remote.RemoteFailure;
	import model.proxies.remote.RemoteProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;

	public class GitProxy extends RemoteProxy {
		
		private static var _request			:GitRequest;
		private static var _account			:HostingAccount;
		private static var _working			:Boolean;		
		private static var _httpsAttempted	:Boolean;
	
		public function GitProxy()
		{
			super.executable = 'BkmkRemote.sh';
		}
		
		protected function get working():Boolean
		{
			return _working;
		}
		
		protected function set request(req:GitRequest):void 
		{ 
			_request = req; _httpsAttempted = false;
		// by default always attempt ssh request in the event user has keys setup //
			if (_request.url.search(/(https:\/\/)(\w*)(@github.com)/) == -1){
				attemptRequest();
			}	else{
		// if we get an https://username@github request, always prepend the user's pass in the url //
				checkUserIsLoggedIn();
			}
		}
		
		private function attemptRequest():void
		{
			trace("GitProxy.attemptRequest()", _request.method, _request.url);
			super.call(Vector.<String>([_request.method, _request.url, _request.args]));
		}

		override protected function onProcessComplete(e:NativeProcessEvent):void
		{
			super.onProcessComplete(e);
			var f:String = RemoteFailure.detectFailure(e.data.result);
			if (f){
				onProcessFailure(f);
			}	else{
				onProcessSuccess(e.data.method);
				if (_account) Hosts.github.writeAcctToDatabase(_account);
			}
			_account = null;
		}
		
		private function onProcessFailure(f:String):void 
		{
			switch(f){
				case RemoteFailure.AUTHENTICATION	:
					onAuthenticationFailure();
				break;
				case RemoteFailure.MALFORMED_URL	:
					dispatchError(ErrEvent.UNRESOLVED_HOST);
				break;
				case RemoteFailure.REPO_NOT_FOUND	:
					dispatchError(ErrEvent.REPO_NOT_FOUND);
				break;
			}
		}
		
		protected function onProcessSuccess(m:String):void { }
		
		private function onAuthenticationFailure():void 
		{ 
			if (hasString(_request.url, 'git://github.com') || hasString(_request.url, 'https://github.com')){
		// a read-only request has failed //	
				dispatchError(ErrEvent.UNRESOLVED_HOST);
			}	else if (hasString(_request.url, 'git@github.com') && !_httpsAttempted){
				trace("GitProxy.onAuthenticationFailure() ssh failure, checking if logged in");
		// user doesn't have an ssh key setup, retry over https //		
				checkUserIsLoggedIn();
			}	else{
		// a beanstalk ssh request or a private github https request has failed //		
				dispatchPermissionsFailure();
			}
		}

		private function checkUserIsLoggedIn():void
		{	
			if (Hosts.github.loggedIn){
				prependHttpsCredentials();
			}	else{
				dispatchPermissionsFailure();
			}
		}
		
		private function prependHttpsCredentials():void
		{
			var u:String = _request.url;
			var n:String = Repository.getAccountName(u);
			var a:HostingAccount = Hosts.github.loggedIn;
			_request.url = Repository.buildHttpsURL(a.user, a.pass, n, u.substr(u.lastIndexOf('/') + 1));
			_httpsAttempted = true;
			attemptRequest();
		}
		
		private function dispatchPermissionsFailure():void
		{
			trace("GitProxy.dispatchPermissionsFailure()", _request.method, _request.url);
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.PERMISSIONS_FAILURE, _request.url);
			AppModel.engine.addEventListener(AppEvent.RETRY_REMOTE_REQUEST, onRetryRequest);
		}
		
		private function onRetryRequest(e:AppEvent):void
		{
			if (e.data.u != null) {
				_request.url = e.data.u; _account = e.data.a;
				attemptRequest();
			}
			AppModel.engine.removeEventListener(AppEvent.RETRY_REMOTE_REQUEST, onRetryRequest);				
		}	
		
		private static function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }		
		
	}
	
}
