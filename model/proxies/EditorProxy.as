package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	import view.bookmarks.Bookmark;

	import flash.filesystem.File;

	public class EditorProxy extends NativeProcessProxy {

		private static var _branch		:BranchProxy;
		private static var _bookmark	:Bookmark;

		public function EditorProxy(p:BranchProxy)
		{
			super.executable = 'Editor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			
			_branch = p;
			_branch.addEventListener(RepositoryEvent.BRANCHES_READ, onBranchesRead);				
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
			_bookmark = b;
			super.call(Vector.<String>([BashMethods.INIT_REPOSITORY, b.local]));				
		}	
		
		public function deleteRepository($o:Object):void 
		{
			super.call(Vector.<String>([BashMethods.DELETE_REPOSITORY, $o.local, $o.killGit, $o.trash]));				
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessComplete(e)", 'method = '+e.data.method, 'result = '+e.data.result);
			switch(e.data.method){
				case BashMethods.TRACK_FILE : 					AppModel.branch.getStatus();				break;				case BashMethods.UNTRACK_FILE : 
					AppModel.branch.getStatus();
				break;
				case BashMethods.COMMIT : 
					AppModel.proxies.status.getStatusAndHistory();				break;
				case BashMethods.INIT_REPOSITORY : 
					_branch.getBranchesOfBookmark(_bookmark);
				break;				
			}
		}
		
		private function onBranchesRead(e:RepositoryEvent):void 
		{
			trace("EditorProxy.onBranchesRead(e)");	
		}			
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("EditorProxy.onProcessFailure(e)");
		}				
		
	}
	
}
