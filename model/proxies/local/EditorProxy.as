package model.proxies.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import system.BashMethods;
	import com.adobe.crypto.MD5;
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
			if (bkmk.type == Bookmark.FOLDER){
				super.directory = bkmk.path;			
				super.call(Vector.<String>([BashMethods.INIT_FOLDER]));
			}	else{
				super.directory =  File.applicationStorageDirectory.nativePath;
				super.call(Vector.<String>([BashMethods.INIT_FILE, bkmk.path, MD5.hash(bkmk.path), bkmk.worktree]));
			}
			dispatchEvent(new AppEvent(AppEvent.INITIALIZING_BOOKMARK, bkmk));
		}	

		public function deleteBookmark(bkmk:Bookmark, trashGit:Boolean, trashFiles:Boolean):void 
		{
			super.directory = bkmk.gitdir;
			var path:String = trashFiles ? bkmk.path : '';
			if (bkmk.type == Bookmark.FOLDER){
				super.call(Vector.<String>([BashMethods.KILL_FOLDER, trashGit, path]));
			}	else{
				super.call(Vector.<String>([BashMethods.KILL_FILE, trashGit, path]));
			}
		}	
		
		public function editAppStorageGitDirName($old:String, $new:String):void
		{
			super.directory =  File.applicationStorageDirectory.nativePath;
			super.call(Vector.<String>([BashMethods.EDIT_GIT_DIR, $old, $new]));
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
		//	trace("EditorProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.COMMIT : 
					AppModel.branch.modified = false;
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE));
				break;
				case BashMethods.INIT_FILE: 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
				break;					
				case BashMethods.INIT_FOLDER : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
				break;	
				case BashMethods.KILL_FILE : 
					dispatchEvent(new AppEvent(AppEvent.FILES_DELETED));
				break;
				case BashMethods.KILL_FOLDER : 
					dispatchEvent(new AppEvent(AppEvent.FILES_DELETED));
				break;								
				case BashMethods.TRACK_FILE : 
				break;				case BashMethods.UNTRACK_FILE : 				break;
				case BashMethods.EDIT_GIT_DIR : 
					dispatchEvent(new AppEvent(AppEvent.GIT_DIR_UPDATED));
				break;	
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'EditorProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}

	}
	
}
