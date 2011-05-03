package model.proxies {

	import events.NativeProcessEvent;
	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;
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
			super.directory = b.gitdir;
		}

		public function commit($msg:String, $addAll:Boolean = false):void
		{
			super.call(Vector.<String>([BashMethods.COMMIT, $msg, $addAll]));
		}
		
		public function trackFile($file:File):void
		{
			super.call(Vector.<String>([BashMethods.TRACK_FILE, $file.nativePath]));
		}
		
		public function unTrackFile($file:File):void
		{
			super.call(Vector.<String>([BashMethods.UNTRACK_FILE, $file.nativePath]));
		}
		
		public function initBookmark(b:Bookmark):void 
		{
			if (b.file.isDirectory){
				super.directory = b.target;			
				super.call(Vector.<String>([BashMethods.INIT_FOLDER]));
			}	else{
				super.directory =  File.applicationStorageDirectory.nativePath;
				super.call(Vector.<String>([BashMethods.INIT_FILE, b.target, b.label, b.worktree]));	
			}
		}	

		public function deleteBookmark(b:Bookmark, args:Object):void 
		{
			super.directory = b.gitdir;
			if (b.file.isDirectory){
				super.call(Vector.<String>([BashMethods.KILL_FOLDER, args.killGit]));
			}	else{
				super.call(Vector.<String>([BashMethods.KILL_FILE, args.killGit]));
			}
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.COMMIT : 
					AppModel.bookmark.initialized = true;
					AppModel.proxies.status.getStatusAndHistory();				break;				case BashMethods.INIT_FILE: 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
				break;					
				case BashMethods.INIT_FOLDER : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
				break;	
				case BashMethods.KILL_FILE : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.DELETED));
				break;
				case BashMethods.KILL_FOLDER : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.DELETED));
				break;								
				case BashMethods.TRACK_FILE : 					AppModel.proxies.status.getStatusOfBranch(AppModel.branch);				break;				case BashMethods.UNTRACK_FILE : 
					AppModel.proxies.status.getStatusOfBranch(AppModel.branch);
				break;
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}

	}
	
}
