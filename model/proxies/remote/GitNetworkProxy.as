package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import events.NativeProcessEvent;
	import model.AppModel;

	public class GitNetworkProxy extends RemoteProxy {
		
		public function GitNetworkProxy()
		{
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			if (super.timerIsRunning == true){
				super.stopTimer();
				if (requestFailed(e.data.result) == false) onProcessSuccess(e.data.method);
			}				
		}
		
		protected function onProcessSuccess(m:String):void { }
		protected function onAuthenticationFailure():void { }
		
		private function requestFailed(s:String):Boolean
		{
			var f:Boolean;
			if (hasString(s, 'The requested URL returned error: 403')){
				f = true;
				onAuthenticationFailure();
			}	else if (hasString(s, 'Permission denied (publickey)')){
				f = true;
				onAuthenticationFailure();
			}	else if (hasString(s, 'ERROR: Permission')){
				f = true;
				onAuthenticationFailure();
			}	else if (hasString(s, 'Authentication failed')){
				f = true;
				onAuthenticationFailure();
			}	else if (hasString(s, 'Couldn\'t resolve host')){
				f = true;
				dispatchFailure(ErrorType.UNRESOLVED_HOST);
			}	else if (hasString(s, 'does not exist')){
				f = true;
				dispatchFailure(ErrorType.UNRESOLVED_HOST);
			}	else if (hasString(s, 'doesn\'t exist. Did you enter it correctly?')){
				f = true;
				dispatchFailure(ErrorType.REPO_NOT_FOUND);
			}	else if (hasString(s, 'fatal: The remote end hung up unexpectedly')){
				f = true;
				dispatchFailure(ErrorType.NO_CONNECTION);
			}	else if (hasString(s, 'fatal:')){
				f = true;
				dispatchFailure('Eek, not sure what just happened, here are the details : '+s);
			}
			if (f) AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));			
			return f;
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }				
		
	}
	
}
