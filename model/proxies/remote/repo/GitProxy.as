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
		
		private static var _request		:GitRequest;
		private static var _account		:HostingAccount;
	
		public function GitProxy()
		{
			super.executable = 'BkmkRemote.sh';
		}
		
		protected function set request(req:GitRequest):void 
		{ 
			_request = req;
			if (_request.url.search(/(https:\/\/)(\w*)(@github.com)/) == -1){
				attemptRequest();
			}	else{
				attemptAccountLookup(_request.url);
			}
		}
		
		private function attemptRequest():void
		{
			super.call(Vector.<String>([_request.method, _request.url, _request.args.join(', ')]));
		}

		override protected function onProcessComplete(e:NativeProcessEvent):void 
		{
		//	trace("GitProxy.onProcessComplete(e)", e.data.method, e.data.result);
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
			trace("GitProxy.onProcessFailure(f)", f);
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
			inspectURL(_request.url);
		}

		private function inspectURL(u:String):void
		{ 
			if (hasString(u, 'git://github.com') || hasString(u, 'https://github.com')){
		// a read-only request has failed //	
				dispatchError(ErrEvent.UNRESOLVED_HOST);
			}	else if (hasString(u, 'git@github.com')){
				attemptAccountLookup(u);
			}	else{
				onPermissionsFailure(u);
			}
		}

		private function attemptAccountLookup(u:String):void
		{
		// only github supports requests over https //	
			var an:String = Repository.getAccountName(u);
			var ha:HostingAccount = Hosts.github.getAccountByProp('acctName', an);
			if (ha){
				_request.url = Repository.buildHttpsURL(ha.user, ha.pass, an, u.substr(u.lastIndexOf('/') + 1));
				attemptRequest();
			}	else{
				onPermissionsFailure(u);		
			}
		}

		private function onPermissionsFailure(u:String):void
		{
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.PERMISSIONS_FAILURE, u);
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
