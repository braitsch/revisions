package model.proxies.local {

	import system.SystemRules;
	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.BashMethods;

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
		
		public function getSummary(e:BookmarkEvent = null):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		public function getModified(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = _bookmark.gitdir;			
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_UNTRACKED_FILES]) ]; 			
		}
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
			switch(a[0].method){
				case BashMethods.GET_LAST_COMMIT :
					onSummary(a);	
				break;
				case BashMethods.GET_MODIFIED_FILES :
					onModified(a);
				break;				
			}
		}
		
		private function onModified(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result;
			var m:Array = ignoreHiddenFiles(splitAndTrim(a[0]));
			var u:Array = ignoreHiddenFiles(splitAndTrim(a[1]));
			trace("StatusProxy.onModified(a)", m.length, m);
			trace("StatusProxy.onModified(a)", u.length, u);
			_bookmark.branch.modified = [m , u];
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.MODIFIED_RECEIVED, _bookmark));			
		}
		//AppModel.proxies.editor.commit('AutoSaved : '+new Date().toLocaleString(), _bookmark);

		private function onSummary(a:Array):void
		{
			getModified(AppModel.bookmark);
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result;
			AppModel.branch.lastCommit = new Commit(a[0], uint(a[1]) + 1);
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SUMMARY_RECEIVED, AppModel.bookmark));
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
			e.data.source = 'StatusProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));			
		}
		
	}
	
}
