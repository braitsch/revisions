package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	import model.Bookmark;

	import flash.filesystem.File;

	public class EditorProxy extends NativeProcessProxy {

		private static var _appStoragePath:String = File.applicationStorageDirectory.nativePath;

		public function EditorProxy()
		{
			super.executable = 'Editor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);			
			super.directory = _appStoragePath;
			super.call(Vector.<String>([BashMethods.INIT_SYSTEM_REPO]));			
		}
		
		public function set bookmark(b:Bookmark):void 
		{
			super.directory = b.local;
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
				super.directory = b.local;			
				super.call(Vector.<String>([BashMethods.INIT_REPOSITORY]));
			}	else{
				super.directory = _appStoragePath;
				trace('calling addFileToSystemRepo');
				super.call(Vector.<String>(['addFileToSystemRepo', b.file.nativePath]));						
			}
		}	

		public function deleteBookmark(b:Bookmark, args:Object):void 
		{
			super.directory = b.local;
			super.call(Vector.<String>([BashMethods.DELETE_REPOSITORY, args.killGit, args.trash]));				
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessComplete(e)", e.data.result);
			switch(e.data.method){
				case BashMethods.COMMIT : 
					AppModel.bookmark.initialized = true;
					AppModel.proxies.status.getStatusAndHistory();				break;				case BashMethods.TRACK_FILE : 					AppModel.proxies.status.getStatusOfBranch(AppModel.branch);				break;				case BashMethods.UNTRACK_FILE : 
					AppModel.proxies.status.getStatusOfBranch(AppModel.branch);
				break;
				case BashMethods.INIT_REPOSITORY : 
					dispatchEvent(new RepositoryEvent(RepositoryEvent.INITIALIZED));
				break;	
				case 'addFileToSystemRepo' :
					dispatchEvent(new RepositoryEvent(RepositoryEvent.INITIALIZED));
				break;					
				case BashMethods.DELETE_REPOSITORY : 
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_DELETED));
				break;					
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessFailure(e)", e.data.result);
		}

	}
	
}
