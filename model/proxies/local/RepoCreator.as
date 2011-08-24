package model.proxies.local {

	import com.adobe.crypto.MD5;
	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import system.BashMethods;

	public class RepoCreator extends NativeProcessProxy {
		
		private static var _files		:Array;
		private static var _index		:uint;
		private static var _bookmark	:Bookmark;
		
		public function RepoCreator()
		{
			super.executable = 'RepoCreator.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function initBookmark(bkmk:Bookmark):void 
		{
			_bookmark = bkmk; _files = null;
			_bookmark.type == Bookmark.FILE ? initFile() : initFolder();
		}
		
		public function killBookmark(bkmk:Bookmark, trashGit:Boolean, trashFiles:Boolean):void 
		{
			if (trashGit){
				var p:String = bkmk.type == Bookmark.FILE ? bkmk.gitdir : bkmk.gitdir+'/.git';
				var g:File = File.desktopDirectory.resolvePath(p);
					g.deleteDirectory(true);
			}
			if (trashFiles){
				var f:File = File.desktopDirectory.resolvePath(bkmk.path);
					f.moveToTrash();
			}
			dispatchEvent(new AppEvent(AppEvent.FILES_DELETED));
		}
		
		public function editAppStorageGitDirName($old:String, $new:String):void
		{
			super.directory =  File.applicationStorageDirectory.nativePath;
			super.call(Vector.<String>([BashMethods.EDIT_GIT_DIR, $old, $new]));
		}
		
	// bookmark initialization sequence //
	
		private function initFile():void
		{
			var hash:String = MD5.hash(_bookmark.path);
			var path:File = File.applicationStorageDirectory.resolvePath(hash);
			if (path.exists == false) path.createDirectory();
			super.directory =  path.nativePath;
			super.call(Vector.<String>([BashMethods.INIT_FILE, _bookmark.path, _bookmark.worktree]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Reading File Contents'}));						
		}
		
		private function initFolder():void
		{
			super.directory = _bookmark.path;			
			super.call(Vector.<String>([BashMethods.INIT_FOLDER]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Reading Directory Contents', prog:true}));
		}
		
	// sub-routines //	
		
		private function getDirectoryFiles():void
		{
			super.call(Vector.<String>([BashMethods.GET_DIRECTORY_FILES]));
		}
		
		private function addFileToRepository(f:String):void
		{
			super.call(Vector.<String>([BashMethods.TRACK_FILE, f]));
		}
		
		private function addFirstCommit():void
		{
			super.directory = _bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_INITIAL_COMMIT]));
		}

	// response handlers //			

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
	//		trace("InitProxy.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.INIT_FILE: 
					onFileInitialized();
				break;					
				case BashMethods.INIT_FOLDER : 
					onFolderInitialized(e.data.result);
				break;	
				case BashMethods.GET_DIRECTORY_FILES : 
					onDirectoryListing(e.data.result);
				break;	
				case BashMethods.TRACK_FILE : 
					onFileAddedToRepository();
				break;									
				case BashMethods.ADD_INITIAL_COMMIT : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
				break;					
				case BashMethods.EDIT_GIT_DIR : 
					dispatchEvent(new AppEvent(AppEvent.GIT_DIR_UPDATED));
				break;	
			}
		}

	// callbacks //	
	
		private function onFileInitialized():void
		{
			addFileToRepository(_bookmark.path);
		}	
		
		private function onFolderInitialized(s:String):void
		{
			if (s == ''){
			// we have no branches, add all files and a first commit //
				getDirectoryFiles();
			}	else{
				dispatchEvent(new BookmarkEvent(BookmarkEvent.INITIALIZED));
			}
		}	

		private function onDirectoryListing(s:String):void
		{
			_index = 0;
			_files = s.split(/\n/g);
			checkArrayForLineBreaks();
			addFileToRepository(_files[_index]);
		}
		
		private function checkArrayForLineBreaks():void
		{
			for (var i:int = 0; i < _files.length; i++) {
				if (_files[i].indexOf('.') != 0){
					_files[i-1]+=_files[i]; _files.splice(i, 1);
				}
			}			
		}
		
		private function onFileAddedToRepository():void
		{
			if (_files == null){
				addFirstCommit();
			}	else{
				addNextFileInQueue();
			}
		}	
		
		private function addNextFileInQueue():void
		{
			if (++_index == _files.length){
				addFirstCommit();
			}	else{
				addFileToRepository(_files[_index]);
			}
			dispatchLoadPercent();
		}
		
	// dispatch //
	
		private function dispatchLoadPercent():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.LOADER_PERCENT, {loaded:_index, total:_files.length}));
		}
			
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'InitProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}

	}
	
}