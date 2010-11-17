package model {
	import events.DataBaseEvent;
	import events.RepositoryEvent;

	

	import flash.events.EventDispatcher;

	// class reposonsible for adding and removing bookmarks from the application //

	public class AppEngine extends EventDispatcher {
		
		private static var _index		:uint = 0;
		private static var _bookmark	:Bookmark;
		private static var _bookmarks	:Vector.<Bookmark> = new Vector.<Bookmark>();

	// expose bookmarks to check against duplicates being added //
			
		static public function get bookmarks():Vector.<Bookmark>
		{
			return _bookmarks;
		}			
		
	// sequence to initalize a new bookmark //

		public function addBookmark(b:Bookmark):void
		{
			_bookmark = b;
			AppModel.database.addRepository(_bookmark.label, _bookmark.local);
			AppModel.database.addEventListener(DataBaseEvent.BOOKMARK_ADDED, initBookmark);			
		}
		
		private function initBookmark(e:DataBaseEvent):void
		{
			AppModel.database.removeEventListener(DataBaseEvent.BOOKMARK_ADDED, initBookmark);
			AppModel.proxies.editor.addBookmark(_bookmark);
			AppModel.proxies.editor.addEventListener(RepositoryEvent.INITIALIZED, readBranches);		}

		private function readBranches(e:RepositoryEvent = null):void 
		{
			AppModel.proxies.editor.removeEventListener(RepositoryEvent.INITIALIZED, readBranches);
			AppModel.proxies.branch.getBranchesOfBookmark(_bookmark);
			AppModel.proxies.branch.addEventListener(RepositoryEvent.BRANCHES_READ, getStashList);
		}

		private function getStashList(e:RepositoryEvent):void 
		{
			AppModel.proxies.branch.removeEventListener(RepositoryEvent.BRANCHES_READ, getStashList);
			AppModel.proxies.branch.getStashList();
			AppModel.proxies.branch.addEventListener(RepositoryEvent.STASH_LIST_READ, onBookmarkReady);
		}

		private function onBookmarkReady(e:RepositoryEvent):void 
		{
			for (var i:int = 0; i < _bookmarks.length; i++) _bookmarks[i].active = false;			
			_bookmarks.push(_bookmark);
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
		
		public function generateBookmarks(a:Array):void 
		{
			var x:Vector.<Bookmark> = new Vector.<Bookmark>();
			
			for (var i:int = 0; i < a.length; i++) {
				var b:Bookmark = new Bookmark(a[i].name, a[i].location, a[i].active == 1);
				_bookmarks.push(b);
				if (b.file.exists == false) x.push(b); 
			}
			trace("BookmarkModel.generateBookmarks(e)", _bookmarks.length, '> bookmark objects created');
			
			if (x.length > 0) {
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_ERROR, x));
			}	else{
				AppModel.proxies.branch.getBranchesOfBookmark(_bookmarks[_index]);				AppModel.proxies.branch.addEventListener(RepositoryEvent.BRANCHES_READ, getStashOfNextBookmark);				AppModel.proxies.branch.addEventListener(RepositoryEvent.STASH_LIST_READ, onStoredBookmarkReady);			}		}			

		private function getStashOfNextBookmark(e:RepositoryEvent):void 
		{
			AppModel.proxies.branch.getStashList();
		}

		private function onStoredBookmarkReady(e:RepositoryEvent):void 
		{
			if (++_index < _bookmarks.length){
				AppModel.proxies.branch.getBranchesOfBookmark(_bookmarks[_index]);	
			}	else{
				AppModel.proxies.branch.removeEventListener(RepositoryEvent.BRANCHES_READ, getStashOfNextBookmark);
				AppModel.proxies.branch.removeEventListener(RepositoryEvent.STASH_LIST_READ, onStoredBookmarkReady);
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_LIST, _bookmarks));
				dispatchActiveBookmark();
			}
		}
		
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
