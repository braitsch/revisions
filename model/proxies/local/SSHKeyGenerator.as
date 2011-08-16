package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;

	public class SSHKeyGenerator extends NativeProcessProxy {
		
		private static var _pbKey		:String;
		
		public function SSHKeyGenerator()
		{
			super.executable = 'SSHKeyGenerator.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		static public function get pbKey():String { return _pbKey; }		

		public function detectApplicationKey():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_SSH_KEY]));
		}	
		
		private function generateKeys():void
		{
			super.call(Vector.<String>([BashMethods.GENERATE_SSH_KEY]));
		}
		
		private function registerKeys():void
		{
			super.call(Vector.<String>([BashMethods.REGISTER_SSH_KEY]));
		}
		
	
	// response handlers //			
		
		private function handleProcessSuccess(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.DETECT_SSH_KEY :
					if(e.data.result == '') {
						generateKeys();
					}	else{ 
						_pbKey = e.data.result;
						dispatchEvent(new AppEvent(AppEvent.SSH_KEY_READY));
					}
				break;		
				case BashMethods.GENERATE_SSH_KEY :
					registerKeys();
				break;	
			}
		}
		
		private function handleProcessFailure(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method; var r:String = e.data.result;
			if (m == BashMethods.REGISTER_SSH_KEY && r.indexOf('Identity added') !=-1){
				detectApplicationKey();
			}	else{
				dispatchDebug(e.data);
			}
		}		
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}			
		
		private function dispatchDebug(o:Object):void
		{
			o.source = 'SSHProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));			
		}

	}
	
}
