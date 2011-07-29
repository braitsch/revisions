package model.proxies {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.BashMethods;
	import com.adobe.crypto.MD5;
	import flash.filesystem.File;

	public class EditorProxy extends NativeProcessProxy {
		
		private static var _bookmark:Bookmark;

		public function EditorProxy()
		{
			super.executable = 'Editor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function commit($msg:String, $b:Bookmark = null):void
		{
			_bookmark = $b ? $b : AppModel.bookmark;
			super.directory = _bookmark.gitdir;
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
					onCommitComplete(e.data.result);
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
			//		AppModel.proxies.status.getStatus();
				break;				case BashMethods.UNTRACK_FILE : 			//		AppModel.proxies.status.getStatus();				break;
				case BashMethods.EDIT_GIT_DIR : 
					dispatchEvent(new AppEvent(AppEvent.GIT_DIR_UPDATED));
				break;	
			}
		}
		
		private function onCommitComplete(s:String):void
		{
			if (_bookmark.branch.history == null){
				_bookmark.branch.clearModified();
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.STATUS, _bookmark));
			}	else{	
			// if we have a history, we always have a status & totalCommit from getSummary //	
				_bookmark.branch.addCommit(new Commit(s, _bookmark.branch.totalCommits + 1));
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SUMMARY, _bookmark));
			}
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE));
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'EditorProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}

	}
	
}
