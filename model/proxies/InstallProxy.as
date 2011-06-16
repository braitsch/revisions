package model.proxies {

	import events.InstallEvent;
	import events.NativeProcessEvent;
	import model.air.NativeProcessQueue;
	import system.BashMethods;

	// installs & updates git if user does not have minimum required version installed.

	public class InstallProxy extends NativeProcessQueue {

		public function InstallProxy()
		{
			super('Install.sh');			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		//	super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onShellQueueComplete);
		}

	// optionally can be called from WindowInstallGit instead of the download function //	
		public function installGitLocal():void
		{
			super.queue = [Vector.<String>([BashMethods.INSTALL_LOCAL])];	
		}
		
		public function downloadAndInstallGit():void
		{
			super.queue = [	Vector.<String>([BashMethods.DOWNLOAD]),
							Vector.<String>([BashMethods.MOUNT]),
							Vector.<String>([BashMethods.INSTALL]),
							Vector.<String>([BashMethods.UNMOUNT]),
							Vector.<String>([BashMethods.TRASH]),
							Vector.<String>([BashMethods.UPDATE_PATH])];
		}
		
	// response handlers //	
	
//		private function onProcessComplete(e:NativeProcessEvent):void
//		{
//	// download by far takes the longest..		
//			switch(e.data.method){
//				case BashMethods.DOWNLOAD : trace('download complete');	break;
//				case BashMethods.MOUNT : trace('mount complete');	break;
//				case BashMethods.INSTALL : trace('install complete');	break;
//				case BashMethods.UNMOUNT : trace('unmount complete');	break;
//				case BashMethods.TRASH : trace('trash complete');	break;
//				case BashMethods.UPDATE_PATH : trace('path update complete');	break;
//			}
//		}			
		
		private function onShellQueueComplete(e:NativeProcessEvent):void 
		{
			dispatchEvent(new InstallEvent(InstallEvent.GIT_INSTALL_COMPLETE));		
		}	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("InstallProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}			
		
	}
	
}
