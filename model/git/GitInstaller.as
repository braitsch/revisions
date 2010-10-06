package model.git {
	import events.InstallEvent;
	import events.NativeProcessEvent;

	import model.SystemRules;
	import model.air.NativeProcessProxy;

	import flash.events.EventDispatcher;

	// installs & updates git if user does not have minimum required version installed.

	public class GitInstaller extends EventDispatcher {

		private static var _proxy			:NativeProcessProxy;
		private static var _gitNotInstalled	:Boolean;

		public function GitInstaller()
		{
			_proxy = new NativeProcessProxy();
			_proxy.executable = 'Install.sh';			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			checkGitIsInstalled();			
		}

		public function install():void
		{
			_proxy.call(Vector.<String>([BashMethods.DOWNLOAD]));						
		}	
		
		private function checkGitIsInstalled():void 
		{
			_proxy.call(Vector.<String>([BashMethods.GET_VERSION]));			
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = String(e.data.method);
			var r:String = String(e.data.result);
			switch(m){
				case BashMethods.GET_VERSION : 
					if (_gitNotInstalled) return;
					var v:String = r.substring(12);
					if (v >= SystemRules.MIN_GIT_VERSION){
						dispatchEvent(new InstallEvent(InstallEvent.SET_GIT_VERSION, v));
					}	else{
						dispatchEvent(new InstallEvent(InstallEvent.GIT_UNAVAILABLE, v));						
					}
				break;	
					
				case BashMethods.DOWNLOAD: 
					_proxy.call(Vector.<String>([BashMethods.MOUNT]));				break;				case BashMethods.MOUNT : 
					_proxy.call(Vector.<String>([BashMethods.INSTALL]));			break;				case BashMethods.INSTALL : 
					_proxy.call(Vector.<String>([BashMethods.UNMOUNT]));			break;				case BashMethods.UNMOUNT : 
					_proxy.call(Vector.<String>([BashMethods.TRASH]));				break;
				case BashMethods.TRASH : 
					_gitNotInstalled = false;
					checkGitIsInstalled();
					dispatchEvent(new InstallEvent(InstallEvent.GIT_INSTALL_COMPLETE));		break;					
			}
		}	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			if (e.data.method==BashMethods.GET_VERSION){
				_gitNotInstalled = true;
				dispatchEvent(new InstallEvent(InstallEvent.GIT_UNAVAILABLE, 0));
			}
		}			
		
	}
	
}
