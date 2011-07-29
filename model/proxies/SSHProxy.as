package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;

	public class SSHProxy extends NativeProcessProxy {
		
		private static var _pbKey		:String;
		private static var _pbKeyId		:String;
		private static var _pbKeyName	:String;
		
		public function SSHProxy()
		{
			super('SSH.sh');
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		static public function get pbKey():String { return _pbKey; }		
		static public function get pbKeyId():String { return _pbKeyId; }	
		static public function get pbKeyName():String { return _pbKeyName; }			

		public function detectSSHKeys($keyName:String):void
		{
			_pbKeyName = $keyName;
			super.call(Vector.<String>([BashMethods.DETECT_SSH_KEYS, _pbKeyName]));
		}	
		
		private function detectKeyId():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_KEY_ID, _pbKeyName]));
		}							
		
		private function generateKeys():void
		{
			super.call(Vector.<String>([BashMethods.GENERATE_SSH_KEYS, _pbKeyName]));
		}
		
		private function registerKeys():void
		{
			super.call(Vector.<String>([BashMethods.REGISTER_SSH_KEYS, _pbKeyName]));
		}
		
	
	// response handlers //			
		
		private function handleProcessSuccess(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.DETECT_SSH_KEYS :
					if(e.data.result != '') {
						_pbKey = e.data.result;
						detectKeyId();
					}	else{ 
						generateKeys();
					}
				break;		
				case BashMethods.GENERATE_SSH_KEYS :
					registerKeys();
				break;	
				case BashMethods.DETECT_KEY_ID :
					_pbKeyId = e.data.result;
					dispatchEvent(new AppEvent(AppEvent.SSH_KEYS_READY));
				break;					
			}
		}
		
		private function handleProcessFailure(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method; var r:String = e.data.result;
			if (m == BashMethods.REGISTER_SSH_KEYS && r.indexOf('Identity added') !=-1){
				detectSSHKeys(_pbKeyName);		
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
