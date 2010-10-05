package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class RepositoryHistory extends EventDispatcher {
		
		private static var _proxy	:NativeProcessProxy;
		private static var _failed	:Boolean;

		public function RepositoryHistory()
		{
			_proxy = new NativeProcessProxy('History.sh');
			_proxy.debug = false;
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_proxy.directory = b.local;
		}		

		public function getHistory():void
		{
			_failed = false;
			_proxy.call(Vector.<String>([BashMethods.GET_HISTORY]));
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			_failed = true;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_UNAVAILABLE));
		}	
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			if (_failed) return;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_RECEIVED, e.data.result.split(/[\n\r\t]/g)));
		}					
		
	}
	
}
