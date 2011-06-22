package model.proxies {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.BashMethods;
	import system.SystemRules;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class StatusProxy extends NativeProcessQueue {

		public static const	T			:uint = 0; // tracked
		public static const	U			:uint = 1; // untracked		public static const	M			:uint = 2; // modified		public static const	I			:uint = 3; // ignored
		
	// automatically call getStatus every ten seconds // 	
		private static var _timer			:Timer = new Timer(5000);
		private static var _working			:Boolean = false;
		private static var _bookmark		:Bookmark;
		private static var _autoSaveQueue	:Array = [];
		
		static public function get working():Boolean { return _working; }		
				public function StatusProxy()
		{
			super('Status.sh');
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_timer.addEventListener(TimerEvent.TIMER, getStatus);
		}
		
	// public methods //	
		
		public function getStatus(e:TimerEvent = null):void
		{
			_working = true;
			resetTimer();
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_TRACKED_FILES]), 
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES]),
							Vector.<String>([BashMethods.GET_MODIFIED_FILES]),	
							Vector.<String>([BashMethods.GET_IGNORED_FILES])];		
		}
				public function getSummary():void
		{
			_working = true;
			resetTimer();
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];					
		}
		
		public function getModified(b:Bookmark):void
		{
			_working = true;
			resetTimer();
			_bookmark = b;
			super.directory = _bookmark.gitdir;			
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]) ]; 			
		}
		
		public function resetTimer():void
		{
			_timer.reset();
			_timer.start();	
		}
		
		public function autosave(b:Bookmark):void
		{
			_autoSaveQueue.push(b);
			trace('_autoSaveQueue length: ' + (_autoSaveQueue.length));
			if (!_working) getModified(_autoSaveQueue[0]);
		}
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
			switch (a.length){
				case 1 : onModified(a);		break;
				case 3 : parseSummary(a);	break;
				case 4 : parseStatus(a);	break;
			}
			_working = false;
		}
		
		private function onModified(a:Array):void
		{
			var m:uint = splitAndTrim(a[0]).length;
			trace("StatusProxy.onModified(a)", m);
			if (m > 0) AppModel.proxies.editor.commit('auto commit', _bookmark);
			_autoSaveQueue.shift();
			if (_autoSaveQueue.length) getModified(_autoSaveQueue[0]);	
		}
		
		private function parseSummary(a:Array):void
		{
			var n:uint = uint(a[2]) + 1;
			AppModel.branch.modified = splitAndTrim(a[0]).length;
			AppModel.branch.totalCommits = n;
			AppModel.branch.lastCommit = new Commit(a[1], n);
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SUMMARY));			
		}

		private function splitAndTrim(s:String):Array
		{
			var x:Array = s.split(/[\n\r\t]/g);
			for (var i:int = 0; i < x.length; i++) if (x[i]=='') x.splice(i, 1);
			return x;		
		}

		private function parseStatus(a:Array):void 
		{
			var i:int = 0, j:int = 0; 
			var m:Boolean = false;
			
			splitAndPurge(a);
			
		// remove modified files from the all tracked files array //
			i = j = 0;
			while(i < a[T].length){
				m = false;
				for (j = 0; j < a[M].length; j++) {
					if (a[T][i] == a[M][j]) {
						a[T].splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}
			
		// remove intentionally ignored files from the untracked files array //			i = j = 0;
			while(i < a[U].length){
				m = false;
				for (j = 0; j < a[I].length; j++) {
					if (a[U][i] == a[I][j]){
						 a[U].splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}						
		//	for (i = 0; i < 4; i++) trace('result set '+i+' = ', r[i]);
			AppModel.branch.status = a;
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.STATUS, a));
		}

		private function splitAndPurge(a:Array):void
		{
		// first split the four returned strings into four arrays //	
			for (var i:int = 0; i < a.length; i++) {
				if (a[i]=='') {
					a[i] = [];
				}	else{
					a[i] = a[i].split(/[\n\r\t]/g);
		// remove any forbidden and / or hidden files //
					purgeForbiddenFiles(a[i]);
				}
			}			
		}

		private function purgeForbiddenFiles(r:Array):void 
		{
			var i:int = 0;
			var m:Boolean = false;
			while(i < r.length){
				m = false;
				for (var k:int = 0; k < SystemRules.FORBIDDEN_FILES.length; k++) {
					if (r[i].indexOf(SystemRules.FORBIDDEN_FILES[k])!=-1) {
						r.splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}	
			if (SystemRules.TRACK_HIDDEN_FILES) return;
			i = 0;
			while(i < r.length){	
				var n:int = r[i].lastIndexOf('/') + 1;
				r[i].indexOf('.')==n ? r.splice(i, 1) : i++;
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("StatusProxy.onProcessFailure(e)", e.data.method);
		}

	}
	
}
