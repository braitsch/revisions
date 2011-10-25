package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import model.vo.Repository;
	import system.BashMethods;
	import flash.filesystem.File;

	public class BkmkEditor extends NativeProcessProxy {

		private static var _branch		:Branch;
		private static var _commit		:Commit;
		private static var _bookmark	:Bookmark;
		private static var _repository	:Repository;

		public function BkmkEditor()
		{
			super.executable = 'BkmkEditor.sh';
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
		
		public function trashUnsaved():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.TRASH_UNSAVED]));
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
		
		public function addTrackingBranches(b:Bookmark):void
		{
			super.appendArgs([b.gitdir, b.worktree]);
			super.call(Vector.<String>([BashMethods.ADD_TRACKING_BRANCHES]));
		}
		
		public function mergeLocalIntoLocal(a:Branch, b:Branch):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE, a.name, b.name]));
		}
		
		public function mergeRemoteIntoLocal():void
		{
			trace("BkmkEditor.mergeRemoteIntoLocal()", AppModel.branch.name, AppModel.repository.name+'/'+AppModel.branch.name);
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE, AppModel.branch.name, AppModel.repository.name+'/'+AppModel.branch.name]));
		}
		
		private function absorbRemoteIntoLocal():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.ABSORB]));
		}
		
	// remotes //	
		
		public function addRemote(r:Repository):void
		{
			_repository = r;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _repository.name, _repository.url, AppModel.branch.name]));			
		}
		
		public function editRemote(b:Bookmark, r:Repository):void
		{
			_repository = r; _bookmark = b;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _repository.name, _repository.url]));			
		}		
		
		public function delRemote(r:Repository):void
		{
			_repository = r;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.DEL_REMOTE, _repository.name]));
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
			trace("BkmkEditor.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method) {
				case BashMethods.COMMIT : 
					onCommitComplete();
				break;
				case BashMethods.COPY_VERSION : 
					onCopyComplete();			
				break;
				case BashMethods.TRASH_UNSAVED: 
					onTrashUnsaved();
				break;				
				case BashMethods.ADD_BRANCH : 
					onBranchAdded();
				break;
				case BashMethods.SET_BRANCH : 
					onBranchSet();
				break;
				case BashMethods.DEL_BRANCH : 
					onBranchDeleted();
				break;								
				case BashMethods.RENAME_BRANCH : 
					onBranchRenamed();
				break;
				case BashMethods.ADD_TRACKING_BRANCHES : 
					onTrackingBranches();
				break;				
				case BashMethods.MERGE :
					onMergeComplete(e.data.result);
				break;	
				case BashMethods.ABSORB :
					onAbsorbComplete(e.data.result);
				break;					
				case BashMethods.ADD_REMOTE :
					onRemoteAdded();
				break;
				case BashMethods.EDIT_REMOTE :
					onRemoteEdited();
				break;				
				case BashMethods.DEL_REMOTE :
					onRemoteRemoved();
				break;					
				case BashMethods.TRACK_FILE : 
				break;
				case BashMethods.UNTRACK_FILE : 
				break;
			}
		}

		private function onCommitComplete():void
		{
			_bookmark.branch.modified = [];
			_bookmark.branch.untracked = [];
			AppModel.dispatch(AppEvent.COMMIT_COMPLETE, _bookmark);
		}
		
		private function onCopyComplete():void
		{
			AppModel.dispatch(AppEvent.COPY_COMPLETE);
		}

		private function onTrashUnsaved():void
		{
			AppModel.dispatch(AppEvent.HISTORY_REVERTED);
		}		
		
		private function onBranchAdded():void
		{
			var h:Vector.<Commit> = AppModel.branch.history;
			for (var i:int = 0; i < h.length; i++) if (h[i].sha1 == _commit.sha1) break;
			var v:Vector.<Commit>  = h.slice(0, i+1);
			_branch.history = v;
			AppModel.bookmark.addLocalBranch(_branch);
			AppModel.dispatch(AppEvent.BRANCH_CHANGED);
		}		

		private function onBranchDeleted():void
		{
			AppModel.bookmark.killLocalBranch(_branch);
			AppModel.dispatch(AppEvent.BRANCH_DELETED);
		}

		private function onBranchSet():void
		{
			AppModel.bookmark.branch = _branch;
			AppModel.dispatch(AppEvent.BRANCH_CHANGED);
		}
		
		private function onBranchRenamed():void
		{
			AppModel.dispatch(AppEvent.BRANCH_RENAMED, AppModel.bookmark);
		}
		
		private function onTrackingBranches():void
		{	
			AppModel.dispatch(AppEvent.TRACKING_BRANCHES_SET);	
		}		
		
		private function onRemoteAdded():void
		{
			AppModel.bookmark.addRemote(_repository);
			AppModel.dispatch(AppEvent.REMOTE_ADDED);
		}
		
		private function onRemoteEdited():void
		{
			AppModel.dispatch(AppEvent.REMOTE_EDITED);
		}		
		
		private function onRemoteRemoved():void
		{
			AppModel.bookmark.delRemote(_repository);
			AppModel.dispatch(AppEvent.REMOTE_DELETED);
		}			

		private function onMergeComplete(s:String):void
		{
			trace("BkmkEditor.onMergeComplete(s)", s);
			if (reponseHas(s, 'Fast-forward')) {
				dispatchBranchSynced();
			}	else{
				trace("--conflict - attempting absorb remote files--");
				absorbRemoteIntoLocal();
			}
		}
		
		private function onAbsorbComplete(s:String):void
		{
			dispatchBranchSynced();
		}
		
		private function dispatchBranchSynced():void
		{
			AppModel.proxies.sync.pushBranch(AppModel.repository);
		}

		private function reponseHas(s1:String, s2:String):Boolean
		{
			return s1.indexOf(s2) != -1;
		}

	}
	
}
