package model {
	import events.DataBaseEvent;
	import events.RepositoryEvent;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	// class reposonsible for adding and removing bookmarks from the application //

	public class AppEngine extends EventDispatcher {
		
		private static var _bookmark	:Bookmark;
		private static var _bookmarks	:Vector.<Bookmark> = new Vector.<Bookmark>();
		
		
	// sequence to initalize a new bookmark //

		public function addBookmark(b:Bookmark):void
		{
			_bookmark = b;
			for (var i:int = 0; i < _bookmarks.length; i++) _bookmarks[i].active = false;
			AppModel.proxies.editor.addBookmark(b);
			AppModel.proxies.editor.addEventListener(RepositoryEvent.INITIALIZED, onBookmarkInitialized);
		}

		private function onBookmarkInitialized(e:RepositoryEvent):void 
		{
			AppModel.proxies.editor.removeEventListener(RepositoryEvent.INITIALIZED, onBookmarkInitialized);
			AppModel.proxies.branch.getBranchesOfBookmark(_bookmark);
			AppModel.proxies.branch.addEventListener(RepositoryEvent.BRANCHES_READ, onBranchesRead);
		}

		private function onBranchesRead(e:RepositoryEvent):void 
		{
			AppModel.proxies.branch.removeEventListener(RepositoryEvent.BRANCHES_READ, onBranchesRead);
			AppModel.database.addRepository(_bookmark.label, _bookmark.local);
			AppModel.database.addEventListener(DataBaseEvent.BOOKMARK_ADDED, onAddedToDatabase);
		}
		
		private function onAddedToDatabase(e:DataBaseEvent):void 
		{
			_bookmarks.push(_bookmark);
			AppModel.database.removeEventListener(DataBaseEvent.BOOKMARK_ADDED, onAddedToDatabase);
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_ADDED, _bookmark));
			dispatchActiveBookmark();
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
			AppModel.database.addEventListener(DataBaseEvent.BOOKMARK_DELETED, onRemovedFromDatabase);
		}

		private function onRemovedFromDatabase(e:DataBaseEvent):void 
		{
			AppModel.database.removeEventListener(DataBaseEvent.BOOKMARK_DELETED, onRemovedFromDatabase);
			removeBookmarkFromList(e.data as Array);
		}

		private function removeBookmarkFromList(a:Array):void 
		{
			trace("AppEngine.removeBookmarkFromList()");
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i] == _bookmark) _bookmarks.splice(i, 1);
			for (var j:int = 0; j < a.length; j++) _bookmarks[j].active = a[j].active;
				
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_DELETED, _bookmark));
			dispatchActiveBookmark();
		}

	// generate bookmarks from database records //		
		
		public function generateBookmarks(e:DataBaseEvent):void 
		{
			var a:Array = e.data as Array;
			var x:Vector.<Bookmark> = new Vector.<Bookmark>();
			
			if (a.length == 0) {
				trace('-- no bookmarks in database, show welcome screen --');
				return;
			}
			
			for (var i:int = 0; i < a.length; i++) {
				var b:Bookmark = new Bookmark(a[i].name, a[i].location, a[i].active == 1);
				_bookmarks.push(b);
				if (b.file.exists == false) x.push(b); 
			}
			trace("BookmarkModel.generateBookmarks(e)", _bookmarks.length, '> bookmark objects created');
			
			if (x.length == 0) {
				AppModel.proxies.branch.getBranchesOfBookmarkQueue(_bookmarks);
				AppModel.proxies.branch.addEventListener(RepositoryEvent.QUEUE_BRANCHES_READ, onQueueBranchesRead);			}	else{
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_ERROR, x));
			}
			
		}			
		
		private function onQueueBranchesRead(e:RepositoryEvent):void 
		{
			trace("BookmarkModel.onQueueBranchesRead(e)");
			AppModel.proxies.branch.removeEventListener(RepositoryEvent.QUEUE_BRANCHES_READ, onQueueBranchesRead);
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_LIST, _bookmarks));
			dispatchActiveBookmark();		}	
		
		private function dispatchActiveBookmark():void 
		{
			if (_bookmarks.length == 0){
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, null));
			} else{
				for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i].active == true) break;
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmarks[i]));
			}
		}						
		
	}
	
}
