package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import system.BashMethods;
	import view.graphics.AppIcon;
	import view.windows.modals.system.Debug;

	public class StatusProxy extends NativeProcessQueue {

		private static var _branch			:Branch;
		private static var _bookmark		:Bookmark;
		
		public function StatusProxy()
		{
			super.executable = 'BkmkStatus.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function getSummary():void
		{
			_branch = AppModel.branch;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY])];
		}
		
		public function getModified(b:Bookmark):void
		{
			_bookmark = b;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES]) ];
		}

		public function getHistory():void
		{
			_branch = AppModel.branch;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]), 
							Vector.<String>([BashMethods.GET_FAVORITES]),
							Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES])];
		}
		
		public function getBranchHistory(b:Branch):void
		{
			_branch = b;
			trace("StatusProxy.getBranchHistory(b)");
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_COMMON_PARENT, AppModel.branch.name, _branch.name]), 
							Vector.<String>([BashMethods.GET_UNIQUE_COMMITS, AppModel.branch.name, _branch.name])];
		}		
		
		public function getRemoteStatus():void
		{
			var r:String = AppModel.bookmark.remote.name;
			var b:String = AppModel.bookmark.branch.name;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.CHERRY_BRANCH, r+'/'+b, b]),
							Vector.<String>([BashMethods.CHERRY_BRANCH, b, r+'/'+b]) ];			
		}
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
			switch(a[0].method){
				case BashMethods.GET_HISTORY :
					a.length == 1 ? onSummary(a) : onHistory(a);
				break;
				case BashMethods.GET_COMMON_PARENT :
					onBranchInspection(a);
				break;				
				case BashMethods.GET_MODIFIED_FILES:
					onModified(a);
				break;
				case BashMethods.CHERRY_BRANCH:
					onRemoteStatus(a);
				break;				
			}
		}

		private function onRemoteStatus(a:Array):void
		{
			if (a[0]==null || a[1]==null) return;
			var n1:Array = splitAndTrim(a[0].result);
			var n2:Array = splitAndTrim(a[1].result);
			if (n1.length) AppModel.branch.remoteStatus = n1.length;
			if (n2.length) AppModel.branch.remoteStatus =-n2.length;
			AppIcon.setApplicationIcon();
			AppModel.dispatch(AppEvent.BRANCH_STATUS);
		}

		private function onModified(a:Array):void
		{
			if (a[0]==null || a[1]==null) return;
			_bookmark.branch.modified = splitAndTrim(a[0].result);
			_bookmark.branch.untracked = splitAndTrim(a[1].result);
			AppModel.dispatch(AppEvent.MODIFIED_RECEIVED, _bookmark);			
		}

		private function onSummary(a:Array):void
		{
			_branch.history = parseHistory(a[0].result);
			AppModel.dispatch(AppEvent.SUMMARY_RECEIVED);
		}

		private function onHistory(a:Array):void
		{
	//		var k:Number = getTimer();
			_branch.history = parseHistory(a[0].result);
			parseFavorites(a[1].result);
			_branch.modified = splitAndTrim(a[2].result);
			_branch.untracked = splitAndTrim(a[3].result);
			AppModel.dispatch(AppEvent.HISTORY_RECEIVED, _branch);
	//		trace("StatusProxy.onHistory - parsed in", getTimer() - k, 'ms');
		}
		
		private function onBranchInspection(a:Array):void
		{
			trace("StatusProxy.onBranchInspection(a)");
			var c:String = a[0].result;
			var v:Vector.<Commit> = parseHistory(a[1].result);
	//		for (var i:int = 0; i < v.length; i++) trace(i, v[i].sha1, v[i].note);	
			AppModel.dispatch(AppEvent.BRANCH_HISTORY, {common:c, unique:v, branch:_branch});
		}		
		
		private function parseHistory(s:String):Vector.<Commit>
		{
			var i:int = 0;
			var a:Array = s.split('-##-').reverse();
			for (i = 0; i < a.length; i++) {
				if (a[i] == '') {
					a.splice(i, 1);
				}	else{
					a[i] = a[i].replace(/[\n\t\r]/g, '');
				}
			}
			var v:Vector.<Commit> = new Vector.<Commit>();
			for (i = 0; i < a.length; i++) v.push(new Commit(a[i], i + 1));	
			return v;
		}
		
		private function parseFavorites(s:String):void
		{
			var f:Array = splitAndTrim(s);
			var v:Vector.<Commit> = _branch.history;
			for (var k:int = 0; k < f.length; k++) {
				for (var x:int = 0; x < v.length; x++) {
					if (v[x].sha1 == f[k].substr(11)){
						v[x].starred = true; break;
					}
				}
			}			
		}

		private function splitAndTrim(s:String):Array
		{
			if (s == null) return [];
			var a:Array = s.split(/[\n\r\t]/g);
			for (var i:int = 0; i < a.length; i++) if (a[i]=='') a.splice(i, 1);
			return a;		
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'StatusProxy.onProcessFailure(e)';
			AppModel.alert(new Debug(e.data));
		}
		
//		private function ignoreHiddenFiles(a:Array):Array
//		{
//			var f:Vector.<String> = SystemRules.FORBIDDEN_FILES;
//			for (var i:int = 0; i < a.length; i++) {
//				for (var j:int = 0; j < f.length; j++) if (a[i].indexOf(f[j]) != -1) {a.splice(i, 1); --i;}
//			}
//			return a;
//		}		
		
//		private function stripDuplicates(a:Array, b:Array):Array
//		{
//			for (var j:int = 0; j < a.length; j++) {
//				for (var k:int = 0; k < b.length; k++) {
//					if (a[j] == b[k]) {
//						a.splice(j, 1); --j; 
//						b.splice(k, 1); continue; 
//					}
//				}		
//			}
//			return a;
//		}		
		
	}
	
}
