package model.proxies {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.BashMethods;

	public class HistoryProxy extends NativeProcessQueue {
		
		private static var _bookmark		:Bookmark;		
		
		public function HistoryProxy()
		{
			super('History.sh');
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);			
		}
		
		public function getHistory($b:Bookmark = null):void
		{
			_bookmark = $b ? $b : AppModel.bookmark;			
			super.directory = _bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]) ];
		}
		
		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
			parseHistory(a[0]); 
		}

		private function parseHistory(s:String):void
		{
			var a:Array = s.split(/[\n\r\t]/g);
			var v:Vector.<Commit> = new Vector.<Commit>();
			for (var i:int = 0; i < a.length; i++) v.push(new Commit(a[i], _bookmark.branch.totalCommits-i));
			_bookmark.branch.history = v;
			AppModel.proxies.status.resetTimer();			
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.HISTORY, _bookmark));			
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}

	}
	
}
