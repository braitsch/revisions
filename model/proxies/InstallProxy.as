package model.proxies {

	import events.InstallEvent;
	import events.NativeProcessEvent;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;
	import flash.events.EventDispatcher;

	// installs & updates git if user does not have minimum required version installed.

	public class InstallProxy extends EventDispatcher {

		private static var _proxy			:NativeProcessProxy;

		public function InstallProxy()
		{
			_proxy = new NativeProcessProxy();
			_proxy.executable = 'Install.sh';			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			_proxy.call(Vector.<String>([BashMethods.DOWNLOAD]));
			trace("InstallProxy.InstallProxy() -------- Installing Git");
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.DOWNLOAD: 
					_proxy.call(Vector.<String>([BashMethods.MOUNT]));				
				break;				case BashMethods.MOUNT : 
					_proxy.call(Vector.<String>([BashMethods.INSTALL]));			
				break;				case BashMethods.INSTALL : 
					_proxy.call(Vector.<String>([BashMethods.UNMOUNT]));			
				break;				case BashMethods.UNMOUNT : 
					_proxy.call(Vector.<String>([BashMethods.TRASH]));				
				break;
				case BashMethods.TRASH : 
					dispatchEvent(new InstallEvent(InstallEvent.GIT_INSTALL_COMPLETE));		
				break;					
			}
		}	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("InstallProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}			
		
	}
	
}
