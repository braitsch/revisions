package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

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
		
		public function addBookmark(b:Bookmark):void 
		{
			super.directory = b.local;			super.call(Vector.<String>([BashMethods.INIT_REPOSITORY, b.local]));				
		}	
		
		public function deleteBookmark(b:Bookmark, args:Object):void 
		{
			super.directory = b.local;
			super.call(Vector.<String>([BashMethods.DELETE_REPOSITORY, b.local, args.killGit, args.trash]));				
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessComplete(e)", 'method = '+e.data.method, 'result = '+e.data.result);
			switch(e.data.method){
				case BashMethods.COMMIT : 
					AppModel.proxies.status.getStatusAndHistory();				break;				case BashMethods.TRACK_FILE : 					AppModel.proxies.status.getStatusOfBranch(AppModel.branch);				break;				case BashMethods.UNTRACK_FILE : 
					AppModel.proxies.status.getStatusOfBranch(AppModel.branch);
				break;
				case BashMethods.INIT_REPOSITORY : 
					dispatchEvent(new RepositoryEvent(RepositoryEvent.INITIALIZED));
				break;	
				case BashMethods.DELETE_REPOSITORY : 
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_DELETED));
				break;					
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessFailure(e)");
		}				
		
	}
	
}
