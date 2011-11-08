package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Branch;
	import model.vo.Commit;
	import system.BashMethods;
	import view.windows.modals.merge.ResolveLocal;
	import view.windows.modals.merge.ResolveRemote;

	public class MergeProxy extends NativeProcessQueue {

		private static var _branch	:Branch;

		public function MergeProxy()
		{
			super.executable = 'BkmkMerge.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onProcessComplete);
		}
		
		public function syncLocal(strategy:String):void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			var m:String = 'SYNC--[ '+AppModel.branch.name+' <--> '+_branch.name+' ]';
			super.call(Vector.<String>([BashMethods.SYNC_LOCAL, AppModel.branch.name, _branch.name, m, strategy]));
		}
		
		public function syncRemote(strategy:String):void
		{
			_branch = null;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			var m:String = 'SYNC--[ '+AppProxies.config.userName+' ]';
			super.call(Vector.<String>([BashMethods.SYNC_REMOTE, AppModel.repository.name+'/'+AppModel.branch.name, m, strategy]));
		}
		
		public function getBranchHistory(b:Branch):void
		{
			_branch = b;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_UNIQUE_COMMITS, AppModel.branch.name, _branch.name]),
							Vector.<String>([BashMethods.GET_UNIQUE_COMMITS, _branch.name, AppModel.branch.name])];
		}			
		
		private function getConflictDetails(branchName:String):void
		{
			super.call(Vector.<String>([BashMethods.GET_LAST_COMMIT, branchName]));	
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
			switch(a[0].method){
				case BashMethods.SYNC_LOCAL :
					onSyncLocal(a[0].result);
				break;
				case BashMethods.SYNC_REMOTE :
					onSyncRemote(a[0].result);
				break;
				case BashMethods.GET_UNIQUE_COMMITS :
					onBranchHistory(a);
				break;											
				case BashMethods.GET_LAST_COMMIT :
					onCompareCommits(a[0].result);
				break;	
			}
		}		
		
		private function onSyncRemote(s:String):void
		{
			if (hasString(s, 'merge attempt failed')){
				getConflictDetails(AppModel.repository.name+'/'+AppModel.branch.name);
			}	else{
				AppProxies.sync.pushBranch(AppModel.repository);
			}
		}
		
		private function onSyncLocal(s:String):void
		{
			if (hasString(s, 'checkout failed, unsaved changes')){
				AppModel.dispatch(AppEvent.SYNC_COMMIT);
				AppModel.dispatch(AppEvent.HIDE_SYNC_VIEW);
			}	else if (hasString(s, 'merge attempt failed')){
				getConflictDetails(_branch.name);
			}	else{
				AppModel.dispatch(AppEvent.HISTORY_REQUESTED);
			}
		}	
		
		private function onCompareCommits(s:String):void
		{
			if (_branch){
				AppModel.alert(new ResolveLocal(parseLogList(s)));
			}	else{
				AppModel.alert(new ResolveRemote(parseLogList(s)));
			}
		}
		
		private function onBranchHistory(a:Array):void
		{
			var branchA:Vector.<Commit> = StatusProxy.parseHistory(a[0].result);
			var branchB:Vector.<Commit> = StatusProxy.parseHistory(a[1].result);
			AppModel.dispatch(AppEvent.BRANCH_HISTORY, {a:branchA, b:branchB, branch:_branch});
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


