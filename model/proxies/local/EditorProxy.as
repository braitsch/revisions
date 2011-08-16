package model.proxies.local {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;
	import flash.filesystem.File;

	public class EditorProxy extends NativeProcessProxy {

		public function EditorProxy()
		{
			super.executable = 'Editor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);			
		}
		
		public function commit($msg:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.COMMIT, $msg]));
		}
		
		public function trackFile($file:File):void
		{
			super.directory = AppModel.bookmark.gitdir;			
			super.call(Vector.<String>([BashMethods.TRACK_FILE, $file.nativePath]));
		}
		
		public function unTrackFile($file:File):void
		{
			super.directory = AppModel.bookmark.gitdir;			
			super.call(Vector.<String>([BashMethods.UNTRACK_FILE, $file.nativePath]));
		}				
	
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.COMMIT : 
					AppModel.branch.modified = [[], []];
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE));
				break;
				case BashMethods.TRACK_FILE : 
				break;
				case BashMethods.UNTRACK_FILE : 
				break;				
			}
		}
	}
	
}
