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
		private var _bookmark	:Bookmark;

		public function RepositoryHistory()
		{
			_proxy = new NativeProcessProxy('History.sh');
			_proxy.debug = true;
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_bookmark = b;
			_proxy.directory = _bookmark.local;
			if (_bookmark.master.history==null) getHistory();
		}		

		public function getHistory():void
		{
		// should only be called when bookmark is first created & when a new commit is entered	
			trace("RepositoryHistory.getHistory()");
			_failed = false;
			_proxy.call(Vector.<String>([BashMethods.GET_HISTORY]));
		}
		
		public function checkoutCommit($sha1:String):void
		{
			_proxy.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, $sha1, _bookmark.branch.modified]));		}
		
		public function checkoutMaster():void 
		{
			_proxy.call(Vector.<String>([BashMethods.CHECKOUT_MASTER, _bookmark.master.modified]));
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			_failed = true;
			switch(e.target.method){
				case BashMethods.CHECKOUT_COMMIT :					trace('local changes');
				break;
				case BashMethods.CHECKOUT_MASTER :					trace('local changes');				break;
				case BashMethods.GET_HISTORY :
					dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_UNAVAILABLE));
				break;
			}
		}	
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("RepositoryHistory.onProcessComplete(e)");
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
					if (_failed) return;
					var a:Array = e.data.result.split(/[\n\r\t]/g);
					AppModel.bookmark.branch.history = a;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_RECEIVED, a));				break;	
				case BashMethods.CHECKOUT_COMMIT :
					_bookmark.branch = _bookmark.detach;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_CHANGED));					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_COMMIT");				break;					
				case BashMethods.CHECKOUT_MASTER :
					_bookmark.branch = _bookmark.master;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_CHANGED));
					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_MASTER");				break;	
			}
		}	
						
	}
	
}
