package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Branch;
	import model.vo.Commit;
	import system.BashMethods;
	import view.windows.modals.merge.ResolveRemote;

	public class MergeProxy extends NativeProcessQueue {

		private static var _branch	:Branch;

		public function MergeProxy()
		{
			super.executable = 'BkmkMerge.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onProcessComplete);
		}
		
		public function syncLocalBranches(b:Branch):void
		{
			_branch = b;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.SYNC_LOCAL_BRANCHES, AppModel.branch.name, _branch.name]));
		}
		
		public function mergeRemoteIntoLocal():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE, AppModel.repository.name, AppModel.branch.name, AppProxies.config.userName]));
		}
		
		public function mergeOurs():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE_OURS, AppModel.repository.name, AppModel.branch.name, AppProxies.config.userName]));			
		}
		
		public function mergeTheirs():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.call(Vector.<String>([BashMethods.MERGE_THEIRS, AppModel.repository.name, AppModel.branch.name, AppProxies.config.userName]));			
		}
		
		public function getBranchHistory(b:Branch):void
		{
			_branch = b;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_COMMON_PARENT, AppModel.branch.name, _branch.name]), 
							Vector.<String>([BashMethods.GET_UNIQUE_COMMITS, AppModel.branch.name, _branch.name])];
		}			
		
		private function getConflictDetails(branchName:String):void
		{
			super.call(Vector.<String>([BashMethods.GET_LAST_COMMIT, branchName]));	
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
		//	trace("BkmkEditor.onProcessComplete(e)", e.data.method, e.data.result);
			switch(a[0].method){
				case BashMethods.MERGE :
					onMergeComplete(a[0].result);
				break;
				case BashMethods.MERGE_OURS :
					onMergeComplete(a[0].result);
				break;
				case BashMethods.MERGE_THEIRS :
					onMergeComplete(a[0].result);
				break;	
				case BashMethods.GET_COMMON_PARENT :
					onBranchInspection(a);
				break;											
				case BashMethods.GET_LAST_COMMIT :
					onCompareCommits(a[0].result);
				break;	
				case BashMethods.SYNC_LOCAL_BRANCHES :
					onLocalSyncComplete(a[0].result);
				break;									
			}
		}		
		
		private function onMergeComplete(s:String):void
		{
			if (hasString(s, 'merge attempt failed')){
				getConflictDetails(AppModel.repository.name+'/'+AppModel.branch.name);
			}	else{
				AppProxies.sync.pushBranch(AppModel.repository);
			}
		}
		
		private function onLocalSyncComplete(s:String):void
		{
			if (hasString(s, 'checkout failed, unsaved changes')){
				AppModel.dispatch(AppEvent.SYNC_COMMIT);
				AppModel.dispatch(AppEvent.HIDE_SYNC_VIEW);
			}	else if (hasString(s, 'merge attempt failed')){
				getConflictDetails(_branch.name);
			}	else{
				trace("MergeProxy.onLocalSyncComplete(s)", s);
			}
		}	
		
		private function onCompareCommits(s:String):void
		{
			AppModel.alert(new ResolveRemote(parseLogList(s)));
		}
		
		private function onBranchInspection(a:Array):void
		{
			var c:String = a[0].result;
			var v:Vector.<Commit> = StatusProxy.parseHistory(a[1].result);
	//		for (var i:int = 0; i < v.length; i++) trace(i, v[i].sha1, v[i].note);	
			AppModel.dispatch(AppEvent.BRANCH_HISTORY, {common:c, unique:v, branch:_branch});
		}		
		
		private function parseLogList(s:String):Array
		{
			var a:Array = s.split('-##-');
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] == '') {
					a.splice(i, 1);
				}	else{
					a[i] = a[i].replace(/[\n\t\r]/g, '');
				}
			}
			return a;
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }						
				
	}
	
}


