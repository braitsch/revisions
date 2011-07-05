package model.proxies {

	import events.AppEvent;
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
		
		public function addListenersToResetTimer():void
		{
			AppModel.engine.addEventListener(BookmarkEvent.HISTORY, resetTimer);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, killTimer);
		}

		private function getStatus(e:TimerEvent):void
		{	
			if (checkBookmarkExists() == false) return;			
			resetTimer();
			_working = true;
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_TRACKED_FILES]), 
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES]),
							Vector.<String>([BashMethods.GET_MODIFIED_FILES]),	
							Vector.<String>([BashMethods.GET_IGNORED_FILES])];
		}
		
		public function getSummary():void
		{
			if (checkBookmarkExists() == false) return;
			resetTimer();
			_working = true;
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		public function getModified(b:Bookmark):void
		{
			resetTimer();
			_working = true;
			_bookmark = b;
			super.directory = _bookmark.gitdir;			
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]) ]; 			
		}
		
		private function checkBookmarkExists():Boolean
		{
			if (AppModel.bookmark.exists){
				return true;
			}	else{
				_timer.stop();
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.PATH_ERROR, AppModel.bookmark));
				return false;				
			}
		}
		
		public function autoSave(b:Bookmark):void
		{
			_autoSaveQueue.push(b);
			if (!_working) getModified(_autoSaveQueue[0]);
		}		
		
		public function resetTimer(e:BookmarkEvent = null):void
		{
			_timer.reset();
			_timer.start();
		}
		
		private function killTimer(e:BookmarkEvent):void
		{
			_timer.stop();
			trace("StatusProxy.killTimer(e)");
		}		
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
		// strip the method names off the result array //	
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result;			
			switch (a.length){
				case 1 : onModified(a);		break;
				case 3 : parseSummary(a);	break;
				case 4 : parseStatus(a);	break;
			}
			_working = false;
		}
		
		private function onModified(a:Array):void
		{
			_autoSaveQueue.shift();
			if (splitAndTrim(a[0]).length > 0) {
				AppModel.engine.addEventListener(BookmarkEvent.COMMIT_COMPLETE, onCommitComplete);
				AppModel.proxies.editor.commit('AutoSaved : '+new Date().toLocaleString(), _bookmark);
			}	else if (_autoSaveQueue.length > 0) {
				getModified(_autoSaveQueue[0]);	
			}
		}

		private function onCommitComplete(e:BookmarkEvent):void
		{
			if (_autoSaveQueue.length > 0) getModified(_autoSaveQueue[0]);	
			AppModel.engine.removeEventListener(BookmarkEvent.COMMIT_COMPLETE, onCommitComplete);			
		}
		
		private function parseSummary(a:Array):void
		{
			var n:uint = uint(a[2]) + 1; // total commits //
			AppModel.branch.setSummary(new Commit(a[1], n), n, splitAndTrim(a[0]));
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SUMMARY, AppModel.bookmark));			
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
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.STATUS, AppModel.bookmark));
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
			var s:String = 'StatusProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}
		
	}
	
}
