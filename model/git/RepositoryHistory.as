package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class RepositoryHistory extends EventDispatcher {
		
		private var _failed		:Boolean;
		private var _proxy		:NativeProcessProxy;

		public function RepositoryHistory()
		{
			_proxy = new NativeProcessProxy('History.sh');
			_proxy.debug = false;
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_proxy.directory = b.local;
			if (b.history==null) getHistory();
		}		

		public function getHistory():void
		{
			trace("RepositoryHistory.getHistory()");
			_failed = false;
			_proxy.call(Vector.<String>([BashMethods.GET_HISTORY]));
		}
		
		public function checkoutCommit($sha1:String, $stash:Boolean):void
		{
			_proxy.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, $sha1, $stash]));		}
		
		public function checkoutMaster():void 
		{
			_proxy.call(Vector.<String>([BashMethods.CHECKOUT_MASTER]));
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			_failed = true;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_UNAVAILABLE));
		}	
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
					if (_failed) return;
					var a:Array = e.data.result.split(/[\n\r\t]/g);
					AppModel.bookmark.history = a;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_RECEIVED, a));
				break;	
				case BashMethods.CHECKOUT_COMMIT :
					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_COMMIT");
				break;					
				case BashMethods.CHECKOUT_MASTER :
					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_MASTER");				break;	
			}
		}					
	}
}
