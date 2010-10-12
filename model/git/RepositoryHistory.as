package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

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
		
		public function getHistoryOfBranch($b:Branch = null):void
		{
			_branch = $b || _bookmark.branch;
			_failed = false;
			trace("RepositoryHistory.getHistory()", _bookmark.label, _branch.name);			_proxy.call(Vector.<String>([BashMethods.GET_HISTORY, _branch.name]));
		}
		
		public function checkoutCommit($sha1:String, $stash:Boolean):void
		{
			if (_bookmark.branch.name!=Bookmark.DETACH) _bookmark.previous = _bookmark.branch;
			
			trace("RepositoryHistory.checkoutCommit($sha1, $stash)", $sha1, $stash);
			_proxy.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, $sha1, $stash]));		}
		
		public function checkoutMaster():void 
		{
			_proxy.call(Vector.<String>([BashMethods.CHECKOUT_MASTER, _bookmark.master.modified]));
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
			trace("******RepositoryHistory.onProcessFailure(e)", e.target.method);
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
			trace("RepositoryHistory.onProcessComplete(e)", 'method = '+e.data.method);
			switch(e.data.method){
				case BashMethods.GET_HISTORY : 
					if (_failed) return;
					_branch.history = e.data.result.split(/[\n\r\t]/g);
				break;	
				case BashMethods.CHECKOUT_COMMIT :
					_bookmark.branch = _bookmark.detach;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_SET));					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_COMMIT");				break;					
				case BashMethods.CHECKOUT_MASTER :
					_bookmark.branch = _bookmark.master;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_SET));
					trace("RepositoryHistory.onProcessComplete(e) > BashMethods.CHECKOUT_MASTER");				break;	
				case BashMethods.ADD_BRANCH : 
					trace('suceess!!');
				break;							
			}
		}	
		
	}
	
}
