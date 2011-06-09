package model.proxies {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	public class HistoryProxy extends NativeProcessProxy {
		
		public function HistoryProxy()
		{
			super.executable = 'History.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function getHistory():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.GET_HISTORY]));
		}
		
		public function getTotalCommits():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.GET_TOTAL_COMMITS]));
		}
		
	// handlers //						
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
			// always force a getStatus after we requesting the branch history //	
					getTotalCommits();
					AppModel.proxies.status.getStatus();
					AppModel.branch.history = e.data.result.split(/[\n\r\t]/g);
					AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.HISTORY));
				break;
				case BashMethods.GET_TOTAL_COMMITS :
			// git log returns one less than the actual commit count //	
					AppModel.branch.totalCommits = Number(e.data.result) + 1;
				break; 				
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}			

	}
	
}
