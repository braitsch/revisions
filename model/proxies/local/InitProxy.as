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

	public class InitProxy extends NativeProcessProxy {
		
		private static var _files	:Array;
		private static var _index	:uint;
		private static var _bookmark:Bookmark;
		
		public function InitProxy()
		{
			super.executable = 'RepoCreator.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function initBookmark(bkmk:Bookmark):void 
		{
			_bookmark = bkmk;
			if (_bookmark.type == Bookmark.FOLDER){
				super.directory = _bookmark.path;			
				super.call(Vector.<String>([BashMethods.INIT_FOLDER]));
			}	else{
				super.directory =  File.applicationStorageDirectory.nativePath;
				super.call(Vector.<String>([BashMethods.INIT_FILE, _bookmark.path, MD5.hash(_bookmark.path), _bookmark.worktree]));
			}
		}
		
		public function killBookmark(bkmk:Bookmark, trashGit:Boolean, trashFiles:Boolean):void 
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
		
	// private //						
		
		private function getDirectoryFiles():void
		{
			super.call(Vector.<String>([BashMethods.GET_DIRECTORY_FILES]));
		}
		
		private function trackFile(s:String):void
		{
			super.call(Vector.<String>([BashMethods.TRACK_FILE, s]));
			// dispatch event that updates the preloader with progress of files added.
		}
		
		private function addFirstCommit():void
		{
			if (_bookmark.type == Bookmark.FOLDER){
				super.directory = _bookmark.path;			
				super.call(Vector.<String>([BashMethods.ADD_INITIAL_COMMIT]));
			}	else{
				super.directory =  File.applicationStorageDirectory.nativePath;
				super.call(Vector.<String>([BashMethods.ADD_INITIAL_COMMIT]));
			}				
		}

	// response handlers //			

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
		//	trace("InitProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.INIT_FILE: 
					onRepositoryInitialized(e.data.result);
				break;					
				case BashMethods.INIT_FOLDER : 
					onRepositoryInitialized(e.data.result);
				break;	
				case BashMethods.GET_DIRECTORY_FILES : 
					onDirectoryFiles(e.data.result);
				break;	
				case BashMethods.TRACK_FILE : 
					onFileAdded();
				break;									
				case BashMethods.ADD_INITIAL_COMMIT : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
				break;					
				case BashMethods.KILL_FILE : 
					dispatchEvent(new AppEvent(AppEvent.FILES_DELETED));
				break;
				case BashMethods.KILL_FOLDER : 
					dispatchEvent(new AppEvent(AppEvent.FILES_DELETED));
				break;								
				case BashMethods.EDIT_GIT_DIR : 
					dispatchEvent(new AppEvent(AppEvent.GIT_DIR_UPDATED));
				break;	
			}
		}
		
	// callbacks //	
		
		private function onRepositoryInitialized(s:String):void
		{
			if (s.indexOf('is already a git repository') != -1){
				trace("InitProxy -- ", s);
			// still need to check that this repo has had files added to it
			// otherwise git branch will fail	
				dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
			}	else{
				getDirectoryFiles();
				dispatchEvent(new AppEvent(AppEvent.INITIALIZING_BOOKMARK, _bookmark));
			}
		}		

		private function onDirectoryFiles(s:String):void
		{
			_files = s.split(/[\n\r\t]/g);
			_index = 0;
			trackFile(_files[_index]);
		}
		
		private function onFileAdded():void
		{
			_index++;
			if (_index < _files.length){
				trackFile(_files[_index]);	
			}	else{
				addFirstCommit();
			}
		}	
		
	// dispatch //
			
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'InitProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}

	}
	
}
