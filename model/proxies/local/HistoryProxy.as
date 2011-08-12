package model.proxies.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessQueue;
	import model.vo.Commit;
	import system.BashMethods;

	public class HistoryProxy extends NativeProcessQueue {
		
		public function HistoryProxy()
		{
			super.executable = 'History.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);			
		}
		
		public function getHistory():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]), 
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
			parseHistory(a[0].result, uint(a[1].result) + 1); 
		}

		private function parseHistory(s:String, n:uint):void
		{
			var a:Array = s.split(/[\n\r\t]/g);
			var v:Vector.<Commit> = new Vector.<Commit>();
			for (var i:int = 0; i < a.length; i++) v.push(new Commit(a[i], n-i));
			AppModel.bookmark.branch.history = v;
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.HISTORY_RECEIVED, AppModel.bookmark));			
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'HistoryProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}

	}
	
}
