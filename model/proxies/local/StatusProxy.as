package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.BashMethods;
	import system.SystemRules;
	import view.modals.system.Debug;
	import flash.utils.setTimeout;

	public class StatusProxy extends NativeProcessQueue {

		public static const	T			:uint = 0; // tracked
		public static const	U			:uint = 1; // untracked		public static const	M			:uint = 2; // modified		public static const	I			:uint = 3; // ignored
		
		private static var _bookmark		:Bookmark;
		
		public function StatusProxy()
		{
			super.executable = 'Status.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function getSummary():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		public function getModified(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = _bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_IGNORED_FILES]),
							Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES]) ];
		}

		public function getHistory(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = _bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]), 
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
			switch(a[0].method){
				case BashMethods.GET_LAST_COMMIT :
					onSummary(a);	
				break;
				case BashMethods.GET_IGNORED_FILES:
					onModified(a);
				break;
				case BashMethods.GET_HISTORY :
					parseHistory(a[0].result, uint(a[1].result) + 1); 
				break;
			}
		}
		
		private function onModified(a:Array):void
		{
			for (var k:int = 0; k < a.length; k++) a[k] = a[k].result;
			var i:Array = ignoreHiddenFiles(splitAndTrim(a[0]));
			var m:Array = ignoreHiddenFiles(splitAndTrim(a[1]));
			var u:Array = ignoreHiddenFiles(splitAndTrim(a[2]));
		// remove all the ignored files from the untracked array //	
			u = stripDuplicates(u, i);
			_bookmark.branch.modified = [m , u];
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.MODIFIED_RECEIVED, _bookmark));			
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
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result;
			AppModel.branch.lastCommit = new Commit(a[0], uint(a[1]) + 1);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SUMMARY_RECEIVED, AppModel.bookmark));
		}

		private function parseHistory(s:String, n:uint):void
		{
			var a:Array = s.split(/[\n\r\t]/g);
			var v:Vector.<Commit> = new Vector.<Commit>();
			for (var i:int = 0; i < a.length; i++) v.push(new Commit(a[i], n-i));
			_bookmark.branch.history = v;
			setTimeout(function():void{ 
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HISTORY_RECEIVED, _bookmark));
			}, 500);
		}	

		private function splitAndTrim(s:String):Array
		{
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
			e.data.source = 'StatusProxy.onProcessFailure(e) -- request on '+_bookmark.label, _bookmark.branch.name;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug(e.data)));
		}
		
	}
	
}
