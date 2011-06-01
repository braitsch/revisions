package model.proxies {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	public class HistoryProxy extends NativeProcessProxy {
		
		public function HistoryProxy()
		{
			super.debug = false;
			super.executable = 'History.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function getHistory():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.GET_HISTORY, AppModel.branch.name]));
			trace("HistoryProxy.getHistory(b) > ", AppModel.bookmark.label, AppModel.branch.name);
		}
		
	// handlers //						
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
			// always force a getStatus after we requesting the branch history //	
					AppModel.proxies.status.getStatus();
					AppModel.branch.history = e.data.result.split(/[\n\r\t]/g);
					AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.HISTORY));
				break;							
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}			

	}
	
}
