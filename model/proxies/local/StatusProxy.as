package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.BashMethods;
	import system.SystemRules;
	import view.graphics.AppIcon;
	import view.windows.modals.system.Debug;

	public class StatusProxy extends NativeProcessQueue {

		private static var _bookmark		:Bookmark;
		
		public function StatusProxy()
		{
			super.executable = 'BkmkStatus.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function getSummary():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		public function getModified(b:Bookmark):void
		{
			_bookmark = b;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_IGNORED_FILES]),
							Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES]) ];
		}

		public function getHistory():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]), 
							Vector.<String>([BashMethods.GET_FAVORITES]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
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
					onHistory(a);
				break;
				case BashMethods.GET_LAST_COMMIT :
					onSummary(a);	
				break;
				case BashMethods.GET_IGNORED_FILES:
					onModified(a);
				break;
				case BashMethods.CHERRY_BRANCH:
					onRemoteStatus(a);
				break;				
			}
		}
		
		private function onRemoteStatus(a:Array):void
		{
			var n1:Array = splitAndTrim(a[0].result);
			var n2:Array = splitAndTrim(a[1].result);
			if (n1.length) AppModel.branch.remoteStatus = n1.length;
			if (n2.length) AppModel.branch.remoteStatus =-n2.length;
			AppIcon.setApplicationIcon();
			AppModel.dispatch(AppEvent.BRANCH_STATUS);
		}

		private function onModified(a:Array):void
		{
			for (var k:int = 0; k < a.length; k++) a[k] = a[k].result;
			if (a[0] == null) trace("StatusProxy.onModified(a) - no ignored files");
			if (a[1] == null) trace("StatusProxy.onModified(a) - no modified files");
			if (a[2] == null) trace("StatusProxy.onModified(a) - no untracked files");
			var i:Array = ignoreHiddenFiles(splitAndTrim(a[0]));
			var m:Array = ignoreHiddenFiles(splitAndTrim(a[1]));
			var u:Array = ignoreHiddenFiles(splitAndTrim(a[2]));
		// remove all the ignored files from the untracked array //	
		//	trace("StatusProxy.modified = (a)", a[1]);
		//	trace("StatusProxy.untracked = (a)", a[2]);
			_bookmark.branch.modified = m;
			_bookmark.branch.untracked = stripDuplicates(u, i);
			AppModel.dispatch(AppEvent.MODIFIED_RECEIVED, _bookmark);			
		}

		private function stripDuplicates(a:Array, b:Array):Array
		{
			for (var j:int = 0; j < a.length; j++) {
				for (var k:int = 0; k < b.length; k++) {
					if (a[j] == b[k]) {
						a.splice(j, 1); --j; 
						b.splice(k, 1); continue; 
					}
				}		
			}
			return a;
		}

		private function onSummary(a:Array):void
		{
			for (var i:int = 0; i < 2; i++) a[i] = a[i].result;
			AppModel.branch.lastCommit = new Commit(a[0], uint(a[1]) + 1);
			AppModel.dispatch(AppEvent.SUMMARY_RECEIVED);
		}

		private function onHistory(a:Array):void
		{
			var h:Array = splitAndTrim(a[0].result);
		//TODO i think we're getting some null arrays here...	
			if (h == null || h.length == 0) trace("StatusProxy.onHistory(a) ------- failure!!");
			var f:Array = splitAndTrim(a[1].result);
			var n:uint = uint(a[2].result) + 1;
			var v:Vector.<Commit> = new Vector.<Commit>();
			for (var i:int = 0; i < h.length; i++) v.push(new Commit(h[i], n-i));
			AppModel.branch.history = v;
			for (var k:int = 0; k < f.length; k++) {
				for (var x:int = 0; x < v.length; x++) {
					if (v[x].sha1 == f[k].substr(11)){
						v[x].starred = true; break;
					}
				}
			}
			AppModel.dispatch(AppEvent.HISTORY_RECEIVED);
		}

		private function splitAndTrim(s:String):Array
		{
			if (s == null) return [];
			var a:Array = s.split(/[\n\r\t]/g);
			for (var i:int = 0; i < a.length; i++) if (a[i]=='') a.splice(i, 1);
			return a;		
		}
		
		private function ignoreHiddenFiles(a:Array):Array
		{
			var f:Vector.<String> = SystemRules.FORBIDDEN_FILES;
			for (var i:int = 0; i < a.length; i++) {
				for (var j:int = 0; j < f.length; j++) if (a[i].indexOf(f[j]) != -1) {a.splice(i, 1); --i;}
			}
			return a;
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.GET_REMOTE_FILES :
					trace("StatusProxy.onProcessFailure(e)", e.data.result);
				break;
				default :
					e.data.source = 'StatusProxy.onProcessFailure(e) -- request on '+_bookmark.label, _bookmark.branch.name;
					AppModel.alert(new Debug(e.data));
				break;
			}
		}
		
	}
	
}
