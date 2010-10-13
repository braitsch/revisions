package model.git {
	import events.RepositoryEvent;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class RepositoryModel extends EventDispatcher {
		
		private static var _proxy		:RepositoryProxy = new RepositoryProxy();
		private static var _editor		:RepositoryEditor = new RepositoryEditor();
		private static var _status 		:RepositoryStatus = new RepositoryStatus();
		private static var _history		:RepositoryHistory = new RepositoryHistory();			

		private static var _bookmark	:Bookmark;
		private static var _bookmarks	:Vector.<Bookmark>;

		public function RepositoryModel()
		{
			_proxy.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady);
			_proxy.addEventListener(RepositoryEvent.BRANCH_DETACHED, onBranchDetached);
		}

	// public setters //

		public function set repositories(a:Array):void
		{
			_proxy.repositories = a;
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_status.bookmark = _history.bookmark = _editor.bookmark = _bookmark;
		//	_bookmark.branch.addEventListener(RepositoryEvent.BRANCH_STATUS, onBranchStatus);
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));			
		}
		
	// public getters //	
		
		public function get bookmark():Bookmark
		{
			return _bookmark;
		}			
		
		public function get editor():RepositoryEditor
		{
			return _editor;
		}
		
		public function get status():RepositoryStatus
		{
			return _status;
		}
		
		public function get history():RepositoryHistory
		{
			return _history;
		}	
		
	// private event handlers //
		
		private function onBookmarksReady(e:RepositoryEvent):void 
		{
			_bookmarks = e.data as Vector.<Bookmark>;
			trace("RepositoryModel.onBookmarksReady(e)");
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY, _bookmarks));
		}
		
		private function onBranchDetached(e:RepositoryEvent):void 
		{
			var b:Bookmark = e.data as Bookmark;
			trace("RepositoryModel.onBranchDetached(e) >> ", b.label);
			// dispatch some event to show modal window...
		}
		
	}
	
}
