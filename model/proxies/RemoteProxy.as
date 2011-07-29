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

		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
		//	trace("RemoteProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.LINK_TO_GITHUB : 
					pushToGitHub();
				break;	
				case BashMethods.PUSH_TO_GITHUB : 
					dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
				break;	
			}
		}
		
		private function handleProcessFailure(e:NativeProcessEvent):void
		{
			dispatchDebug(e.data);
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}			
		
		private function dispatchDebug(o:Object):void
		{
			o.source = 'RemoteProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));
		}		

	}
	
}
