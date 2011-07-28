package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;
	
	public class RemoteProxy extends NativeProcessProxy {
		
		public function RemoteProxy()
		{
			super.executable = 'Remote.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function linkToGitHub($url:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.LINK_TO_GITHUB, $url]));
		}
		
		public function pushToGitHub():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_TO_GITHUB]));
		}			

		private function onProcessComplete(e:NativeProcessEvent):void
		{
			trace("RemoteProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.LINK_TO_GITHUB : 
					pushToGitHub();
				break;	
				case BashMethods.PUSH_TO_GITHUB : 
					dispatchEvent(new AppEvent(AppEvent.GIT_DIR_UPDATED));
				break;	
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void
		{
			trace("RemoteProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}
		
	}
	
}
