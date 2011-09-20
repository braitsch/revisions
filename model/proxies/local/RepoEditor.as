package model.proxies.local {

	import model.vo.Bookmark;
	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import system.BashMethods;
	import view.modals.system.Debug;
	import flash.filesystem.File;

	public class RepoEditor extends NativeProcessProxy {

		private static var _bookmark:Bookmark;

		public function RepoEditor()
		{
			super.executable = 'RepoEditor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function commit($msg:String):void
		{
			_bookmark = AppModel.bookmark;
			super.directory = _bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.COMMIT, $msg]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Saving Changes'}));
		}
		
		public function autoSave(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = _bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.COMMIT, 'Auto Saved :: '+new Date().toLocaleString()]));
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
		
		public function changeBranch(name:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.CHANGE_BRANCH, name]));
		}
		
		public function revert(sha1:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.REVERT_TO_VERSION, sha1]));			
		}
		
		public function download(sha1:String, saveAs:String, file:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.DOWNLOAD_VERSION, sha1, saveAs, file]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method) {
			// auto update the history after reverting to an earlier version //	
				case BashMethods.REVERT_TO_VERSION : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.REVERTED));
				break;
				case BashMethods.CHANGE_BRANCH : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCH_CHANGED));
				break;
				case BashMethods.COMMIT : 
					_bookmark.branch.modified = [[], []];
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE, _bookmark));
				break;
				case BashMethods.TRACK_FILE : 
				break;
				case BashMethods.UNTRACK_FILE : 
				break;					
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'CheckoutProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug(e.data)));
		}
		
	}
	
}
