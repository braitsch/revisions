package model {
	import events.DataBaseEvent;
	import events.RepositoryEvent;

	import model.db.AppDatabase;
	import model.proxies.AppProxies;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class BookmarkModel extends EventDispatcher {
		
		private static var _proxies		:AppProxies;		private static var _database	:AppDatabase;
		
		private static var _bookmark	:Bookmark;
		private static var _bookmarks	:Vector.<Bookmark>;	

		public function BookmarkModel(p:AppProxies, d:AppDatabase) 
		{
			_database = d;
			_database.addEventListener(DataBaseEvent.REPOSITORIES, generateBookmarks);
			
			_proxies = p;
			_proxies.editor.addEventListener(RepositoryEvent.BOOKMARK_ADDED, onNewBookmarkAdded);
			_proxies.branch.addEventListener(RepositoryEvent.QUEUE_BRANCHES_READ, onQueueBranchesRead);			
		}

		// bookmark //

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));			
		}
		
		public function get bookmark():Bookmark
		{
			return _bookmark;
		}	
		
	// private methods //	
		
		private function generateBookmarks(e:DataBaseEvent):void 
		{
			var bkmk:Vector.<Bookmark> = new Vector.<Bookmark>();
			var fail:Vector.<Bookmark> = new Vector.<Bookmark>();
			
			var a:Array = e.data as Array;
			for (var i:int = 0; i < a.length; i++) {
				var b:Bookmark = new Bookmark(a[i].name, a[i].location, a[i].active == 1);
				bkmk.push(b);
				if (b.file.exists == false) fail.push(b); 
			}
			_bookmarks = bkmk;
			trace("BookmarkModel.generateBookmarks(e)", _bookmarks.length, '> bookmark objects created');
			
			if (fail.length == 0) {
				_proxies.branch.getBranchesOfBookmarkQueue(_bookmarks);
			}	else{
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_ERROR, fail));
			}
			
		}			
		
		private function onQueueBranchesRead(e:RepositoryEvent):void 
		{
			trace("BookmarkModel.onBookmarksReady(e)");
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY, _bookmarks));		}	
		
		private function onNewBookmarkAdded(e:RepositoryEvent):void 
		{
			var b:Bookmark = e.data as Bookmark;
			_bookmarks.push(b);
			AppModel.database.addRepository(b.label, b.local);
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY, _bookmarks));
		}				
		
	}
	
}
