package model.proxies.remote.base {

	import model.vo.BookmarkRemote;
	import events.AppEvent;
	import events.ErrorType;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import system.BashMethods;

	public class GitProxy extends NetworkProxy {
		
		private static var _request		:GitRequest;
		private static var _account		:HostingAccount;
	
		public function GitProxy()
		{
			super.executable = 'RepoRemote.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		protected function set request(req:GitRequest):void 
		{ 
			_request = req;
			attemptRequest();
		}
		
		private function attemptRequest():void
		{
			super.startTimer();
			trace("GitProxy.attemptRequest()", _request.method, _request.url, _request.args.join(', '));
			super.call(Vector.<String>([_request.method, _request.url, _request.args.join(', ')]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			if (super.timerIsRunning == true){
				super.stopTimer();
				handleResponse(e.data.method, e.data.result);
			} 	else if (e.data.method == BashMethods.CLONE) {
				handleResponse(e.data.method, e.data.result);
			}
		}
		
		private function handleResponse(m:String, r:String):void
		{
			var f:String = GitFailure.detectFailure(r);
			if (f){
				onProcessFailure(f);
			}	else{
				onProcessSuccess(m);
				if (_account) Hosts.github.writeAcctToDatabase(_account);
			}
			_account = null;
		}
		
		private function onProcessFailure(f:String):void 
		{
			switch(f){
				case GitFailure.AUTHENTICATION	:
					onAuthenticationFailure();
				break;
				case GitFailure.MALFORMED_URL	:
					dispatchFailure(ErrorType.UNRESOLVED_HOST);
				break;
				case GitFailure.REPO_NOT_FOUND	:
					dispatchFailure(ErrorType.REPO_NOT_FOUND);
				break;
			}
		}
		
		protected function onProcessSuccess(m:String):void { }
		protected function onAuthenticationFailure():void 
		{ 
			inspectURL(_request.url);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
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
		
		protected function inspectURL(u:String):void
		{ 
			if (hasString(u, 'git://github.com') || hasString(u, 'https://github.com')){
		// a read-only request has failed //	
				dispatchFailure('Sorry could not connect to that url. Are you sure you entered it correctly?');
			}	else if (hasString(u, 'git@github.com')){
				attemptAccountLookup(u);
			}	else{
				onPermissionsFailure(u);
			}
		}

		private function attemptAccountLookup(u:String):void
		{
		// only github supports requests over https //	
			var an:String = BookmarkRemote.getAccountName(u);
			var ha:HostingAccount = Hosts.github.getAccountByProp('acct', an);
			if (ha){
				_request.url = BookmarkRemote.buildHttpsURL(ha.user, ha.pass, an, u.substr(u.lastIndexOf('/') + 1));
				attemptRequest();
			}	else{
				onPermissionsFailure(u);		
			}
		}

		private function onPermissionsFailure(u:String):void
		{
	// 	https://acctName@github.com requests & all git@acctName.beanstalk requests
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.PERMISSIONS_FAILURE, u));
		}
		
		private static function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }		
		
	}
	
}
