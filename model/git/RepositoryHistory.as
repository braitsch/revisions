package model.git {
	import events.NativeProcessEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;
	import view.history.HistoryItem;

	import flash.events.EventDispatcher;

	public class RepositoryHistory extends EventDispatcher {
		
		private static var _proxy		:NativeProcessProxy;
		private static var _branch		:Branch;
		private static var _bookmark	:Bookmark;

		public function RepositoryHistory()
		{
			_proxy = new NativeProcessProxy('History.sh');
			_proxy.debug = false;
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_bookmark = b;
			_proxy.directory = _bookmark.local;
		}
		
		public function getHistoryOfBranch(b:Branch):void
		{
			_branch = b;
			_proxy.call(Vector.<String>([BashMethods.GET_HISTORY, _branch.name]));
		}
		
		public function checkout(n:HistoryItem):void 
		{
			trace("RepositoryHistory.checkout(sha1, index, mod)", n.sha1, n.name, n.index, 'mod = ',_bookmark.branch.modified);
			
		// record where we are before we detach the head //	
			if (_bookmark.branch.name != Bookmark.DETACH) _bookmark.previous = _bookmark.branch;
			
			if (n.index==0){
				_proxy.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, n.name, _bookmark.previous.modified]));
			} else{
				_proxy.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, n.sha1, _bookmark.branch.modified]));
			}
		}		
		
		public function addBranch($name:String):void
		{
			trace("RepositoryHistory.addBranch($new)", $name, AppModel.repos.bookmark.previous.name);
			_proxy.call(Vector.<String>([BashMethods.ADD_BRANCH, $name, AppModel.repos.bookmark.previous.name]));
		}	
		
		public function discardUnsavedChanges():void
		{
			_proxy.call(Vector.<String>([BashMethods.RESET_BRANCH]));
		}
		
	// handlers //					
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("RepositoryHistory.onProcessFailure(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.GET_HISTORY :
					_branch.history = null;
				break;				case BashMethods.CHECKOUT_COMMIT :
				break;				case BashMethods.CHECKOUT_BRANCH :
				break;
			}
		}	
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("RepositoryHistory.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
					_branch.history = e.data.result.split(/[\n\r\t]/g);
				break;	
				case BashMethods.CHECKOUT_COMMIT :
					_bookmark.branch = _bookmark.detach;
				break;					
				case BashMethods.CHECKOUT_BRANCH :
					_bookmark.branch = _bookmark.previous;
				break;	
				case BashMethods.ADD_BRANCH : 
				break;							
			}
		}	

	}
	
}
