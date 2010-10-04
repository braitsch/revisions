package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.air.NativeProcessQueue;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class RepositoryHistory extends EventDispatcher {
		
		private static var _shas:Array = [];		private static var _authors:Array = [];		private static var _dates:Array = [];		private static var _notes:Array = [];
		private static var _proxy:NativeProcessQueue;

		public function RepositoryHistory()
		{
			_proxy = new NativeProcessQueue('History.sh');
			_proxy.debug = false;
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onShellProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onShellQueueComplete);		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_proxy.directory = b.local;
		}		

		public function getHistory():void
		{
			trace("RepositoryHistory.getHistory()");
			_proxy.queue = getHistoryTransaction();	
		}
		
	// private 	
		
		private function onShellQueueComplete(e:NativeProcessEvent):void 
		{
			trace("RepositoryHistory.onShellQueueComplete(e)");
			var r:Array = e.data as Array;
			if (r.length==4) onHistoryComplete(r);
		}
		
		private function onShellProcessFailure(e:NativeProcessEvent):void 
		{
			trace("RepositoryHistory.onShellProcessFailure(e)");
			dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_UNAVAILABLE));
		}		

		private function onHistoryComplete(r:Array):void 
		{
			parseShas(r[0]);
			parseDates(r[1]);			parseAuthors(r[2]);			
			parseNotes(r[3]);						dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_RECEIVED, 
				{dates:_dates, authors:_authors, notes:_notes}));
		}

		private function parseShas(s:String):void 
		{
			_shas = s.split(/[\n\r\t]/g);		}
		
		private function parseDates(s:String):void 
		{
			_dates = s.split(/[\n\r\t]/g);		}				private function parseAuthors(s:String):void 
		{
			_authors = s.split(/[\n\r\t]/g);
		}
		
		private function parseNotes(s:String):void 
		{
			_notes = s.split(/[\n\r\t]/g);
		}
		
		private function getHistoryTransaction():Array
		{
			return [	Vector.<String>([BashMethods.GET_SHAS]), 
						Vector.<String>([BashMethods.GET_DATES]),												
						Vector.<String>([BashMethods.GET_AUTHORS]),												
						Vector.<String>([BashMethods.GET_NOTES])];		
		}		
		
	}
	
}
