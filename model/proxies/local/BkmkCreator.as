package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import system.BashMethods;
	import view.windows.modals.system.Debug;
	import com.adobe.crypto.MD5;
	import flash.filesystem.File;

	public class BkmkCreator extends NativeProcessProxy {
		
		private static var _files		:Array;
		private static var _index		:uint;
		private static var _bookmark	:Bookmark;
		
		public function BkmkCreator()
		{
			super.executable = 'BkmkCreator.sh';
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
			AppModel.dispatch(AppEvent.FILES_DELETED);
		}
		
		public function editAppStorageGitDirName(o:Object):void
		{
			super.appendArgs([File.applicationStorageDirectory.nativePath]);
			super.call(Vector.<String>([BashMethods.EDIT_GIT_DIR, o.oldFile, o.newFile, o.oldMD5, o.newMD5]));
		}
		
	// bookmark initialization sequence //
	
		private function initFile():void
		{
			var hash:String = MD5.hash(_bookmark.path);
			var path:File = File.applicationStorageDirectory.resolvePath(hash);
			if (path.exists == false) path.createDirectory();
			AppModel.showLoader('Reading File Contents');
			super.call(Vector.<String>([BashMethods.INIT_FILE, path.nativePath, _bookmark.worktree]));
		}
		
		private function initFolder():void
		{
			AppModel.showLoader('Reading Directory Contents', true);
			super.appendArgs([_bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.INIT_FOLDER]));
		}
		
	// sub-routines //	
		
		private function getDirectoryFiles():void
		{
			super.appendArgs([_bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.GET_DIRECTORY_FILES]));
		}
		
		private function addFileToRepository(f:String):void
		{
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.TRACK_FILE, f]));
		}
		
		private function addFirstCommit():void
		{
			super.appendArgs([_bookmark.gitdir]);
			super.call(Vector.<String>([BashMethods.ADD_INITIAL_COMMIT]));
		}

	// response handlers //			

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
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
					AppModel.dispatch(AppEvent.INITIALIZED);
				break;					
				case BashMethods.EDIT_GIT_DIR : 
					AppModel.dispatch(AppEvent.GIT_DIR_UPDATED);
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
				AppModel.dispatch(AppEvent.INITIALIZED);
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
			AppModel.dispatch(AppEvent.LOADER_PERCENT, {loaded:_index, total:_files.length});
		}
			
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'RepoCreator.onProcessFailure(e)';
			AppModel.alert(new Debug(e.data));
		}

	}
	
}
