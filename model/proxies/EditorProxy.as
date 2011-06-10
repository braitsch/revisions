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
		
		public function initBookmark(bkmk:Bookmark):void 
		{
			if (bkmk.file.isDirectory){
				super.directory = bkmk.target;			
				super.call(Vector.<String>([BashMethods.INIT_FOLDER]));
			}	else{
				super.directory =  File.applicationStorageDirectory.nativePath;
				super.call(Vector.<String>([BashMethods.INIT_FILE, bkmk.target, bkmk.label, bkmk.worktree]));	
			}
		}	

		public function deleteBookmark(bkmk:Bookmark, trashGit:Boolean, trashFiles:Boolean):void 
		{
			super.directory = bkmk.gitdir;
			var target:String = trashFiles ? bkmk.target : '';
			trace('bkmk.target = '+target);
			if (bkmk.file.isDirectory){
				super.call(Vector.<String>([BashMethods.KILL_FOLDER, trashGit, target]));
			}	else{
				super.call(Vector.<String>([BashMethods.KILL_FILE, trashGit, target]));
			}
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.COMMIT : 
			// refresh the app views after every commit //	
					AppModel.proxies.history.getHistoryAndSummary();
				break;
				case BashMethods.INIT_FILE: 
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
				case BashMethods.TRACK_FILE : 
					AppModel.proxies.status.getStatus();
				break;				case BashMethods.UNTRACK_FILE : 					AppModel.proxies.status.getStatus();				break;
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}

	}
	
}
