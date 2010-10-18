package model {
	import events.DataBaseEvent;
	import events.RepositoryEvent;
	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class BookmarkEngine extends EventDispatcher{

		private static var _bookmark:Bookmark;

	// sequence to initalize a new bookmark //

		public function addBookmark(b:Bookmark):void
		{
			_bookmark = b;
			AppModel.proxies.editor.addBookmark(b);
			AppModel.proxies.editor.addEventListener(RepositoryEvent.INITIALIZED, onBookmarkAdded);		}

		private function onBookmarkAdded(e:RepositoryEvent):void 
		{
			AppModel.proxies.editor.removeEventListener(RepositoryEvent.INITIALIZED, onBookmarkAdded);
			AppModel.proxies.branch.getBranchesOfBookmark(_bookmark);
			AppModel.proxies.branch.addEventListener(RepositoryEvent.BRANCHES_READ, onBranchesRead);		}

		private function onBranchesRead(e:RepositoryEvent):void 
		{
			AppModel.proxies.branch.removeEventListener(RepositoryEvent.BRANCHES_READ, onBranchesRead);
			AppModel.database.addRepository(_bookmark.label, _bookmark.local);			AppModel.database.addEventListener(DataBaseEvent.BOOKMARK_ADDED, onAddedToDatabase);
		}
		private function onAddedToDatabase(e:DataBaseEvent):void 
		{
			AppModel.database.removeEventListener(DataBaseEvent.BOOKMARK_ADDED, onAddedToDatabase);
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_ADDED, _bookmark));
		}
		
	// sequence to remove a bookmark //	

		public function deleteBookmark(b:Bookmark, args:Object):void
		{
			_bookmark = b;
			AppModel.proxies.editor.deleteBookmark(b, args);		
			AppModel.proxies.editor.addEventListener(RepositoryEvent.BOOKMARK_DELETED, onBookmarkDeleted);				
		}
			
		private function onBookmarkDeleted(e:RepositoryEvent):void 
		{
			AppModel.database.deleteRepository(_bookmark.label);
			AppModel.database.addEventListener(DataBaseEvent.BOOKMARK_DELETED, onRemovedFromDatabase);		}

		private function onRemovedFromDatabase(e:DataBaseEvent):void 
		{
			AppModel.database.removeEventListener(DataBaseEvent.BOOKMARK_DELETED, onRemovedFromDatabase);
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_DELETED, _bookmark));
		}
		
	}
	
}
