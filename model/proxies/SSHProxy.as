package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;

	public class SSHProxy extends NativeProcessProxy {
		
		private static var _publicKey	:String;
		
		public function SSHProxy()
		{
			super('SSH.sh');
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		static public function get publicKey():String
		{
			return _publicKey;
		}		

		public function detectSSHKeys():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_SSH_KEYS]));
		}	
		
		private function generateKeys():void
		{
			super.call(Vector.<String>([BashMethods.GENERATE_SSH_KEYS]));
		}
		
		private function registerKeys():void
		{
			super.call(Vector.<String>([BashMethods.REGISTER_SSH_KEYS]));
		}				
	
	// response handlers //			
		
		private function handleProcessSuccess(e:NativeProcessEvent):void 
		{
			trace("SSHProxy.handleProcessSuccess(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.DETECT_SSH_KEYS :
					if(e.data.result == '') {
						generateKeys();
					}	else{ 
						onKeysDetected(e.data.result);
					}
				break;		
				case BashMethods.GENERATE_SSH_KEYS :
					registerKeys();
				break;	
			}
		}
		
		private function handleProcessFailure(e:NativeProcessEvent):void 
		{
			trace("SSHProxy.handleProcessFailure(e)", e.data.method);			
			var m:String = e.data.method; var r:String = e.data.result;
			if (m == BashMethods.REGISTER_SSH_KEYS && r.indexOf('Identity added') !=-1){
				detectSSHKeys();		
			}	else{
				dispatchDebug(m, r);
			}
		}		
		
		private function onKeysDetected(s:String):void
		{
			_publicKey = s;
			dispatchEvent(new AppEvent(AppEvent.SSH_KEYS_READY));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}			
		
		private function dispatchDebug(m:String, r:String):void
		{
			var s:String = 'SSHProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:m, r:r}));
		}

	}
	
}
