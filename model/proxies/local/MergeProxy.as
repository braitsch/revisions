package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.proxies.air.NativeProcessProxy;
	import model.vo.Branch;
	import system.BashMethods;
	import view.windows.modals.merge.ResolveRemote;

	public class MergeProxy extends NativeProcessProxy {

		private static var _branch	:Branch;

		public function MergeProxy()
		{
			super.executable = 'BkmkMerge.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
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
		
		private function getConflictDetails(branchName:String):void
		{
			super.call(Vector.<String>([BashMethods.COMPARE_COMMITS, branchName]));	
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
		//	trace("BkmkEditor.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method) {
				case BashMethods.MERGE :
					onMergeComplete(e.data.result);
				break;
				case BashMethods.MERGE_OURS :
					onMergeComplete(e.data.result);
				break;
				case BashMethods.MERGE_THEIRS :
					onMergeComplete(e.data.result);
				break;								
				case BashMethods.COMPARE_COMMITS :
					onCompareCommits(e.data.result);
				break;	
				case BashMethods.SYNC_LOCAL_BRANCHES :
					onLocalSyncComplete(e.data.result);
				break;									
			}
		}		
		
		
// merge local & remote //			

		private function onMergeComplete(s:String):void
		{
			if (hasString(s, 'merge attempt failed')){
				getConflictDetails(AppModel.repository.name+'/'+AppModel.branch.name);
			}	else{
				AppProxies.sync.pushBranch(AppModel.repository);
			}
		}
		
	// merge local & local //
	
		private function onLocalSyncComplete(s:String):void
		{
			if (hasString(s, 'checkout failed, unsaved changes')){
				AppModel.dispatch(AppEvent.SYNC_COMMIT);
				AppModel.dispatch(AppEvent.HIDE_SYNC_VIEW);
			}	else if (hasString(s, 'merge attempt failed')){
				getConflictDetails(_branch.name);
			}	else{
				trace("BkmkEditor.onLocalSyncComplete(s)", s);
			}
		}	
		
		private function onCompareCommits(s:String):void
		{
			AppModel.alert(new ResolveRemote(parseLogList(s)));
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
