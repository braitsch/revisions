package model.git.repo {
	import events.NativeProcessEvent;

	import model.air.NativeProcessProxy;
	import model.git.bash.BashMethods;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	public class HistoryProxy extends NativeProcessProxy {
		
		private static var _branch		:Branch;
		private static var _bookmark	:Bookmark;

		public function HistoryProxy()
		{
			super.debug = false;
			super.executable = 'History.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_bookmark = b;
			super.directory = _bookmark.local;
		}
		
		public function getHistoryOfBranch(b:Branch):void
		{
			_branch = b;
			super.call(Vector.<String>([BashMethods.GET_HISTORY, _branch.name]));
		}
		
	// handlers //					
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessFailure(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.GET_HISTORY :
					_branch.history = null;
				break;
			}
		}	
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("HistoryProxy.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
					_branch.history = e.data.result.split(/[\n\r\t]/g);
				break;							
			}
		}	

	}
	
}
