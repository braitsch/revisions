package model.git.repo {
	import events.RepositoryEvent;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class RepositoryProxy extends EventDispatcher {
		
		private static var _branch		:BranchProxy = new BranchProxy();
		private static var _editor		:EditorProxy = new EditorProxy();
		private static var _status 		:StatusProxy = new StatusProxy();
		private static var _history		:HistoryProxy = new HistoryProxy();	
		private static var _checkout	:CheckoutProxy = new CheckoutProxy();		

		private static var _bookmark	:Bookmark;
		private static var _bookmarks	:Vector.<Bookmark>;

		public function RepositoryProxy()
		{
			_branch.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady);
		}

	// public setters //

		public function set repositories(a:Array):void
		{
			_branch.repositories = a;
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_status.bookmark = _history.bookmark = _editor.bookmark = _bookmark;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));			
		}
		
	// public getters //	
		
		public function get bookmark():Bookmark
		{
			return _bookmark;
		}			
		
		public function get editor():EditorProxy
		{
			return _editor;
		}

		public function get branch():BranchProxy
		{
			return _branch;
		}
		
		public function get status():StatusProxy
		{
			return _status;
		}
		
		public function get history():HistoryProxy
		{
			return _history;
		}
		
		public function get checkout():CheckoutProxy
		{
			return _checkout;
		}		
		
	// private event handlers //
		
		private function onBookmarksReady(e:RepositoryEvent):void 
		{
			_bookmarks = e.data as Vector.<Bookmark>;
			trace("RepositoryProxy.onBookmarksReady(e)");
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY, _bookmarks));
		}
		
	}
	
}
