package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;
	import view.history.HistoryItem;

	import flash.events.EventDispatcher;

	public class RepositoryHistory extends EventDispatcher {
		
		private static var _failed		:Boolean;
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
			_failed = false;
			trace("RepositoryHistory.getHistory()", _bookmark.label, _branch.name);			_proxy.call(Vector.<String>([BashMethods.GET_HISTORY, _branch.name]));
		}
		
		public function checkout(n:HistoryItem):void 
		{
			trace("RepositoryHistory.checkout(sha1, index, mod)", n.sha1, n.name, n.index, 'mod = ',_bookmark.branch.modified);
			if (n.index==0){
				trace('_bookmark.previous.modified: ' + (_bookmark.previous.modified));
				_proxy.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, n.name, _bookmark.previous.modified]));
			} else{
			// record where we were before we detach the head //	
				if (_bookmark.branch.name!='detach') _bookmark.previous = _bookmark.branch;
				trace('setting previous to :', _bookmark.previous.name, _bookmark.previous.modified);
				_proxy.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, n.sha1, _bookmark.branch.modified]));
			}
		}		
		
		public function addBranch($new:String):void
		{
			trace("RepositoryHistory.addBranch($new)", $new, AppModel.bookmark.previous.name);
			_proxy.call(Vector.<String>([BashMethods.ADD_BRANCH, $new, AppModel.bookmark.previous.name]));
		}	
		
		public function discardUnsavedChanges():void
		{
			_proxy.call(Vector.<String>([BashMethods.RESET_BRANCH]));
		}
		
	// handlers //					
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("******RepositoryHistory.onProcessFailure(e)", e.data.method, e.data.result);
			_failed = true;
			switch(e.data.method){
				case BashMethods.CHECKOUT_COMMIT :					trace('local changes');
				break;
				case BashMethods.CHECKOUT_BRANCH :					trace('local changes');				break;
				case BashMethods.GET_HISTORY :
					dispatchEvent(new RepositoryEvent(RepositoryEvent.HISTORY_UNAVAILABLE));
				break;
			}
		}	
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("RepositoryHistory.onProcessComplete(e)", 'method = '+e.data.method);
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
					if (_failed) return;
					_branch.history = e.data.result.split(/[\n\r\t]/g);
				break;	
				case BashMethods.CHECKOUT_COMMIT :
					_bookmark.branch = _bookmark.detach;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_SET));					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_COMMIT");				break;					
				case BashMethods.CHECKOUT_BRANCH :
					_bookmark.branch = _bookmark.previous;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_SET));
					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_BRANCH");				break;	
				case BashMethods.ADD_BRANCH : 
					trace('suceess!!');
				break;							
			}
		}	

	}
	
}
