package model.proxies {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.Commit;
	import model.air.NativeProcessQueue;
	import model.bash.BashMethods;

	public class HistoryProxy extends NativeProcessQueue {
		
		public function HistoryProxy()
		{
			super('History.sh');
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);			
		}
		
		public function getHistory():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]) ];
		}
		
		public function getSummaryDetails():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];
		}
		
		public function getHistoryAndSummary():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.queue = [	Vector.<String>([BashMethods.GET_HISTORY]),
							Vector.<String>([BashMethods.GET_LAST_COMMIT]),
							Vector.<String>([BashMethods.GET_TOTAL_COMMITS]) ];			
		}		
		
	// handlers //						
		
		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
			switch(a.length){
				case 1 : parseHistory(a); break;
				case 2 : parseSummary(a); break;
				case 3 : 
					parseHistory(a.shift());
					parseSummary(a);
				break;
			}
		}

		private function parseSummary(a:Array):void
		{
			// the last commit //
			var d:Array = a[0].split('##');
			var c:Commit = new Commit({	index:0,
										sha1	:d[0],
										date	:d[1],
										author	:d[2],
										note	:d[3],
										branch	:AppModel.branch});
			// total commits - git log returns one less than the actual commit count //	
			AppModel.branch.lastCommit = c;
			AppModel.branch.totalCommits = Number(a[1]) + 1;
		}

		private function parseHistory(a:Array):void
		{
			// always force a getStatus after we requesting the branch history //	
			AppModel.proxies.status.getStatus();
			AppModel.branch.history = a[0].split(/[\n\r\t]/g);
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.HISTORY));			
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}

	}
	
}
