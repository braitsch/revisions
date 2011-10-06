package model.proxies.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import system.BashMethods;
	import view.windows.modals.system.Debug;
	import flash.filesystem.File;

	public class RepoEditor extends NativeProcessProxy {

		private static var _branch		:Branch;
		private static var _commit		:Commit;
		private static var _bookmark	:Bookmark;

		public function RepoEditor()
		{
			super.executable = 'RepoEditor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function commit($msg:String):void
		{
			_bookmark = AppModel.bookmark;
			AppModel.showLoader('Saving Changes');
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.COMMIT, $msg]));
		}
		
		public function autoSave(b:Bookmark):void
		{
			_bookmark = b;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.COMMIT, 'Auto Saved :: '+new Date().toLocaleString()]));
		}
		
		public function starCommit(o:Commit):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.STAR_COMMIT, o.sha1]));
		}
		
		public function unstarCommit(o:Commit):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.UNSTAR_COMMIT, o.sha1]));			
		}
		
	// branching //	
		
		public function addBranch(name:String, cmt:Commit):void
		{
			_branch = new Branch(name); _commit = cmt;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.ADD_BRANCH, name, cmt.sha1]));
		}
		
		public function changeBranch(b:Branch):void
		{
			_branch = b;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.SET_BRANCH, _branch.name]));
		}
		
		public function renameBranch(o:String, n:String):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.RENAME_BRANCH, o, n]));			
		}		
		
		public function killBranch(b:Branch):void
		{
			_branch = b;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.DEL_BRANCH, _branch.name]));
		}
		
		public function merge(a:Branch, b:Branch):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE, a.name, b.name]));
		}
		
	// other stuff //			
		
		public function copyVersion(sha1:String, saveAs:String):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.COPY_VERSION, AppModel.branch.name, sha1, AppModel.bookmark.path, saveAs]));
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
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
		//	trace("RepoEditor.onProcessComplete(e)", e.data.method, e.data.result);
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
					_bookmark.branch.modified = [];
					_bookmark.branch.untracked = [];
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE, _bookmark));
				break;
				case BashMethods.MERGE : 
					onMergeComplete(e.data.result);
				break;	
				case BashMethods.ADD_BRANCH : 
					onBranchCreated();
				break;	
				case BashMethods.DEL_BRANCH : 
					onBranchDeleted();
				break;								
				case BashMethods.RENAME_BRANCH : 
					dispatchEvent(new AppEvent(AppEvent.BRANCH_RENAMED, AppModel.bookmark));
				break;
				case BashMethods.TRACK_FILE : 
				break;
				case BashMethods.UNTRACK_FILE : 
				break;
				case BashMethods.STAR_COMMIT : 
				break;
				case BashMethods.UNSTAR_COMMIT : 
				break;				
				default :
					e.data.source = 'RepoEditor.onProcessFailure(e)';
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug(e.data)));				
				break;
			}
		}
		
		private function onBranchCreated():void
		{
			var h:Vector.<Commit> = AppModel.branch.history;
			for (var i:int = 0; i < h.length; i++) if (h[i].sha1 == _commit.sha1) break;
			var v:Vector.<Commit>  = h.slice(0, i+1);
			_branch.history = v;
			AppModel.bookmark.addLocalBranch(_branch);
			dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCH_CHANGED));
		}		

		private function onBranchDeleted():void
		{
			AppModel.bookmark.killLocalBranch(_branch);
			dispatchEvent(new AppEvent(AppEvent.BRANCH_DELETED));
		}

		private function onBranchSet():void
		{
			AppModel.bookmark.branch = _branch;
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
		}

	}
	
}
