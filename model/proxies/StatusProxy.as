package model.proxies {

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
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
							Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		public function getModified(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = _bookmark.gitdir;			
			super.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]) ]; 			
		}
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
		// strip the method names off the result array //	
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result;			
			switch (a.length){
				case 1 : onModified(a);		break;
				case 3 : onSummary(a);		break;
			}
		}
		
		private function onModified(a:Array):void
		{
			var k:Array = splitAndTrim(a[0]);
			trace("StatusProxy.onModified(a)", k);
		}
		//AppModel.proxies.editor.commit('AutoSaved : '+new Date().toLocaleString(), _bookmark);

		private function onSummary(a:Array):void
		{
			var n:uint = uint(a[2]) + 1; // total commits //
			AppModel.branch.setSummary(new Commit(a[1], n), n, splitAndTrim(a[0]));
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SUMMARY_RECEIVED, AppModel.bookmark));
		}

		private function splitAndTrim(s:String):Array
		{
			var x:Array = s.split(/[\n\r\t]/g);
			for (var i:int = 0; i < x.length; i++) if (x[i]=='') x.splice(i, 1);
			return x;		
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'StatusProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));			
		}
		
	}
	
}
