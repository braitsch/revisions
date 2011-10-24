package model.proxies.remote.repo {

	import events.AppEvent;
	import events.ErrEvent;
	import events.NativeProcessEvent;
	import model.proxies.remote.RemoteFailure;
	import model.proxies.remote.RemoteProxy;

	public class GitProxy extends RemoteProxy {
		
		private static var _request			:GitRequest;
		private static var _working			:Boolean;		
		private static var _repairProxy		:RepairProxy = new RepairProxy();
	
		public function GitProxy()
		{
			super.executable = 'BkmkRemote.sh';
			_repairProxy.addEventListener(AppEvent.REMOTE_REPAIRED, onRemoteRepaired);
			_repairProxy.addEventListener(AppEvent.REQUEST_CANCELLED, onRequestCancelled);
		}

		protected function get working():Boolean
		{
			return _working;
		}
		
		protected function set request(req:GitRequest):void 
		{ 
			_request = req;
		// by default always attempt ssh request in the event user has keys setup //
			if (_request.url.search(/(https:\/\/)(\w*)(@github.com)/) == -1){
				attemptRequest();
			}	else{
		// if we get an https://username@github request, always prepend the user's pass in the url //
				_repairProxy.request = req;
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
			}
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
			}	else if (hasString(_request.url, 'git@github.com')){
		// user doesn't have an ssh key setup, retry over https //		
				_repairProxy.request = _request;
			}	else{
		// a beanstalk ssh request or a private github https request has failed //		
				_repairProxy.request = _request;
			}
		}
		
		private function onRemoteRepaired(e:AppEvent):void
		{
			onProcessSuccess(e.data.method);
		}
		
		private function onRequestCancelled(e:AppEvent):void
		{
			_working = false;
			trace("GitProxy.onRequestCancelled(e)");
		}			
		
		private static function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }		
		
	}
	
}
