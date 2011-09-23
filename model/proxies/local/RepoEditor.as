package model.proxies.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import system.BashMethods;
	import view.modals.system.Debug;
	import flash.filesystem.File;

	public class RepoEditor extends NativeProcessProxy {

		private static var _bookmark	:Bookmark;

		public function RepoEditor()
		{
			super.executable = 'RepoEditor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function commit($msg:String):void
		{
			_bookmark = AppModel.bookmark;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.COMMIT, $msg]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Saving Changes'}));
		}
		
		public function autoSave(b:Bookmark):void
		{
			_bookmark = b;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.COMMIT, 'Auto Saved :: '+new Date().toLocaleString()]));
		}
		
		public function merge(a:Branch, b:Branch):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE, a.name, b.name]));
		}
		
		public function trackFile($file:File):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.TRACK_FILE, $file.nativePath]));
		}
		
		public function unTrackFile($file:File):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.UNTRACK_FILE, $file.nativePath]));
		}
		
		public function addBranch():void
		{
			
		}
		
		public function changeBranch(b:Branch):void
		{
			AppModel.bookmark.branch = b;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.SET_BRANCH, b.name]));
		}
		
		public function renameBranch(o:String, n:String):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.RENAME_BRANCH, o, n]));			
		}		
		
		public function killBranch():void
		{
			
		}
		
		public function revert(sha1:String):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.REVERT_TO_VERSION, sha1]));			
		}
		
		public function copyVersion(sha1:String, saveAs:String):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.COPY_VERSION, AppModel.branch.name, sha1, AppModel.bookmark.path, saveAs]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method) {
			// auto update the history after reverting to an earlier version //	
				case BashMethods.REVERT_TO_VERSION : 
					dispatchEvent(new BookmarkEvent(BookmarkEvent.REVERTED));
				break;
				case BashMethods.COPY_VERSION : 
				break;				
				case BashMethods.SET_BRANCH : 
					onBranchSet();
				break;
				case BashMethods.COMMIT : 
					_bookmark.branch.modified = [[], []];
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE, _bookmark));
				break;
				case BashMethods.MERGE : 
					onMergeComplete(e.data.result);
				break;	
				case BashMethods.RENAME_BRANCH : 
					dispatchEvent(new AppEvent(AppEvent.BRANCH_RENAMED, AppModel.bookmark));
				break;								
				case BashMethods.TRACK_FILE : 
				break;
				case BashMethods.UNTRACK_FILE : 
				break;					
			}
		}

		private function onBranchSet():void
		{
			dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCH_CHANGED));
		}

		private function onMergeComplete(s:String):void
		{
			trace("RepoEditor.onMergeComplete(s)", s);
			var ok:Boolean;
			if (reponseHas(s, 'Fast-forward')) ok = true;
			if (reponseHas(s, 'Already up-to-date')) ok = true;
			if (ok) {
				dispatchEvent(new BookmarkEvent(BookmarkEvent.MERGE_COMPLETE));
			}	else{
				trace("there was a conflict");
			}
		}

		private function reponseHas(s1:String, s2:String):Boolean
		{
			return s1.indexOf(s2) != -1;
;		}		
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'CheckoutProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug(e.data)));
		}

	}
	
}
