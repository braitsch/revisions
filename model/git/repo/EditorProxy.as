package model.git.repo {
	import events.NativeProcessEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.git.bash.BashMethods;

	import view.bookmarks.Bookmark;

	import flash.filesystem.File;

	public class EditorProxy extends NativeProcessProxy {

		public function EditorProxy()
		{
			super.executable = 'Editor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function set bookmark(b:Bookmark):void 
		{
			super.directory = b.local;
		}

		public function commit($msg:String):void
		{
			super.call(Vector.<String>([BashMethods.COMMIT, $msg]));					
		}
		
		public function trackFile($file:File):void
		{
			super.call(Vector.<String>([BashMethods.TRACK_FILE, $file.nativePath]));
		}
		
		public function unTrackFile($file:File):void
		{
			super.call(Vector.<String>([BashMethods.UNTRACK_FILE, $file.nativePath]));
		}
		
		public function initRepository($local:String):void 
		{
			super.call(Vector.<String>([BashMethods.INIT_REPOSITORY, $local]));				
		}	
		
		public function deleteRepository($o:Object):void 
		{
			super.call(Vector.<String>([BashMethods.DELETE_REPOSITORY, $o.local, $o.killGit, $o.trash]));				
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessComplete(e)", 'method = '+e.data.method, 'result = '+e.data.result);
			switch(e.data.method){
				case BashMethods.TRACK_FILE : 					AppModel.branch.getStatus();				break;				case BashMethods.UNTRACK_FILE : 
					AppModel.branch.getStatus();
				break;
				case BashMethods.COMMIT : 
					AppModel.proxy.status.getStatusAndHistory();				break;
			}
		}	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessFailure(e)");
		}				
		
	}
	
}
