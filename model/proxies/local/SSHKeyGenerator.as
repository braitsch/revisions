package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import system.BashMethods;
	import view.windows.modals.system.Debug;

	public class SSHKeyGenerator extends NativeProcessProxy {
		
		private static var _pbKey				:String;
		private static var _pbKeyName			:String;
		
		public function SSHKeyGenerator()
		{
			super.executable = 'SSHKeyGenerator.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		static public function get pbKey()		:String 	{ return _pbKey;		}
		static public function get pbKeyName()	:String 	{ return _pbKeyName;	}

		public function initialize():void { getHostName(); }
		
		private function getHostName():void
		{
			super.call(Vector.<String>([BashMethods.GET_HOST_NAME]));	
		}
		
		private function detectKey():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_SSH_KEY]));
		}	
		
		private function createKey():void
		{
			super.call(Vector.<String>([BashMethods.CREATE_SSH_KEY]));
		}
		
		private function addKeyToSSHAuthAgent():void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEY_TO_AUTH_AGENT]));
		}
		
	// response handlers //			
		
		private function handleProcessSuccess(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.GET_HOST_NAME :
					_pbKeyName = 'Revisions - '+e.data.result.replace(/-/g, ' ');
					detectKey();
				break; 
				case BashMethods.DETECT_SSH_KEY :
					if(e.data.result == '') {
						createKey();
					}	else{ 
						_pbKey = e.data.result;
						addKeyToSSHAuthAgent();
					}
				break;		
				case BashMethods.CREATE_SSH_KEY :
					detectKey();
				break;	
			}
		}
		
		private function handleProcessFailure(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method; var r:String = e.data.result;
			if (m == BashMethods.ADD_KEY_TO_AUTH_AGENT && r.indexOf('Identity added') !=-1){
				dispatchEvent(new AppEvent(AppEvent.SSH_KEY_READY));
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug(o)));			
		}

	}
	
}
