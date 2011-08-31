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
		
		private static var _urlErrors:Vector.<String> = new <String>[	'Unable to find remote helper',
																		'does not exist',
																		'doesn\'t exist. Did you enter it correctly?',
																		'Could not find Repository',
																		'Failed connect to',
																		'Couldn\'t resolve host'	];
																		
		private static var _keyErrors:Vector.<String> = new <String>[	
			'Permission denied',
			'Authentication failed',
			'Host key verification failed',
			'Your key is not attached to the repository and account you are trying to access.'];
		
		public function GitProxy()
		{
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("GitProxy.onProcessComplete(e)", e.data.method, e.data.result);
			if (super.timerIsRunning == true){
				super.stopTimer();
				handleResponse(e.data.method, e.data.result);
			} else if (e.data.method == BashMethods.CLONE){
				handleResponse(e.data.method, e.data.result);
			}
		}
		
		private function handleResponse(m:String, r:String):void
		{
			if (requestFailed(m, r) == false) onProcessSuccess(m);	
		}
		
		protected function onProcessSuccess(m:String):void { }
		protected function onAuthenticationFailure():void { }
		
		private function requestFailed(m:String, s:String):Boolean
		{
			var f:Boolean;
			if (detectKeyErrors(s)){
				f = true;
				onAuthenticationFailure();
			}	else if (detectURLErrors(s)){
				f = true;
				dispatchFailure(ErrorType.UNRESOLVED_HOST);
			}	else if (hasString(s, 'doesn\'t exist. Did you enter it correctly?')){
				f = true;
				dispatchFailure(ErrorType.REPO_NOT_FOUND);
			}	else if (hasString(s, 'git/info/refs not found')){
				f = true;
				dispatchFailure(ErrorType.REPO_NOT_FOUND);								
			}	else if (hasString(s, 'fatal: The remote end hung up unexpectedly')){
				f = true;
				dispatchFailure(ErrorType.NO_CONNECTION);
			}	else if (hasString(s, 'fatal:')){
				f = true;
				dispatchDebug({source:'GitProxy.requestFailed()', method:m, message:s});
			}
			return f;
		}
		
		private function detectKeyErrors(s:String):Boolean
		{
			for (var i:int = 0; i < _keyErrors.length; i++) {
				if (hasString(s, _keyErrors[i])) return true;
			}
			return false;
		}
		
		private function detectURLErrors(s:String):Boolean
		{
			for (var i:int = 0; i < _urlErrors.length; i++) {
				if (hasString(s, _urlErrors[i])) return true;
			}
			return false;
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}

		private function attemptAccountLookup(u:String):void
		{
	//	git@github.com:acctName/repo-name.git
			var an:String = BookmarkRemote.getAccountName(u);
			var ha:HostingAccount = Hosts.github.getAccountByProp('acct', an);
			if (ha){
				u = BookmarkRemote.buildHttpsURL(ha.user, ha.pass, an, u.substr(u.lastIndexOf('/') + 1));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, u));
			}	else{
				onPermissionsFailure(u);		
			}
		}

		private function onPermissionsFailure(u:String):void
		{
	// 	https://acctName@github.com requests & all git@acctName.beanstalk requests
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.PERMISSIONS_FAILURE, u));
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }				
		
	}
	
}
