package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;

	public class SSHProxy extends NativeProcessProxy {
		
		public function SSHProxy()
		{
			super.executable = 'SSH.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function checkForKeys():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_SSH_KEYS]));
		}
		
		public function addKeysToGitHub():void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEYS_TO_GITHUB]));
		}		
		
			
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("SSHProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.DETECT_SSH_KEYS : 
					dispatchEvent(new AppEvent(AppEvent.SSH_KEYS_VALID));
				break;	
				case BashMethods.ADD_KEYS_TO_GITHUB : 
	
				break;						
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'SSHProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}

	}
	
}
