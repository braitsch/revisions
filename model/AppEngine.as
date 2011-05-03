package model {

	import events.DataBaseEvent;
	import events.BookmarkEvent;
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
			AppModel.database.addRepository(_bookmark.label, _bookmark.target);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_ADDED, initBookmark);			
		}
		
		private function initBookmark(e:DataBaseEvent):void
		{
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_ADDED, initBookmark);
			AppModel.proxies.editor.initBookmark(_bookmark);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.INITIALIZED, readBranches);
		}

		private function readBranches(e:BookmarkEvent = null):void 
		{
			AppModel.proxies.editor.removeEventListener(BookmarkEvent.INITIALIZED, readBranches);
			AppModel.proxies.branch.getBranchesOfBookmark(_bookmark);
			AppModel.proxies.branch.addEventListener(BookmarkEvent.BRANCHES_READ, getStashList);
		}

		private function getStashList(e:BookmarkEvent):void 
		{
			AppModel.proxies.branch.removeEventListener(BookmarkEvent.BRANCHES_READ, getStashList);
			AppModel.proxies.branch.getStashList();
			AppModel.proxies.branch.addEventListener(BookmarkEvent.STASH_LIST_READ, onBookmarkReady);
		}

		private function onBookmarkReady(e:BookmarkEvent):void 
		{
			for (var i:int = 0; i < _bookmarks.length; i++) _bookmarks[i].active = false;			
			_bookmarks.push(_bookmark);
			dispatchEvent(new BookmarkEvent(BookmarkEvent.ADDED, _bookmark));
			dispatchActiveBookmark();
		}

	// sequence to remove a bookmark //	

		public function deleteBookmark(b:Bookmark, args:Object):void
		{
			_bookmark = b;
			AppModel.proxies.editor.deleteBookmark(b, args);		
			AppModel.proxies.editor.addEventListener(BookmarkEvent.DELETED, onBookmarkDeleted);				
		}
			
		private function onBookmarkDeleted(e:BookmarkEvent):void 
		{
			AppModel.database.deleteRepository(_bookmark.label);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_DELETED, onRemovedFromDatabase);
		}

		private function onRemovedFromDatabase(e:DataBaseEvent):void 
		{
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_DELETED, onRemovedFromDatabase);
			removeBookmarkFromList(e.data as Array);
		}

		private function removeBookmarkFromList(a:Array):void 
		{
			trace("AppEngine.removeBookmarkFromList()");
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i] == _bookmark) _bookmarks.splice(i, 1);
			for (var j:int = 0; j < a.length; j++) _bookmarks[j].active = a[j].active;
				
			dispatchEvent(new BookmarkEvent(BookmarkEvent.DELETED, _bookmark));
			if (_bookmarks.length > 0) {
				dispatchActiveBookmark();
			}	else{
				dispatchEvent(new BookmarkEvent(BookmarkEvent.NO_BOOKMARKS));
			}
		}
		
	// generate bookmarks from database records //		
		
		public function generateBookmarks(a:Array):void 
		{
			var x:Vector.<Bookmark> = new Vector.<Bookmark>();
			
			for (var i:int = 0; i < a.length; i++) {
				var o:Object = {
					label	:	a[i].label,
					target	:	a[i].target,
					local	:	a[i].local,
					remote 	:	a[i].remote,
					active 	:	a[i].active
				};
				var b:Bookmark = new Bookmark(o);
				_bookmarks.push(b);
				if (b.file.exists == false) x.push(b);
			}
			if (x.length > 0) {
				dispatchEvent(new BookmarkEvent(BookmarkEvent.PATH_ERROR, x));
			}	else{
				AppModel.proxies.branch.getBranchesOfBookmark(_bookmarks[_index]);				AppModel.proxies.branch.addEventListener(BookmarkEvent.BRANCHES_READ, getStashOfNextBookmark);				AppModel.proxies.branch.addEventListener(BookmarkEvent.STASH_LIST_READ, onStoredBookmarkReady);			}		}
		
		private function getStashOfNextBookmark(e:BookmarkEvent):void 
		{
			AppModel.proxies.branch.getStashList();
		}

		private function onStoredBookmarkReady(e:BookmarkEvent):void 
		{
			if (++_index < _bookmarks.length){
				AppModel.proxies.branch.getBranchesOfBookmark(_bookmarks[_index]);	
			}	else{
				AppModel.proxies.branch.removeEventListener(BookmarkEvent.BRANCHES_READ, getStashOfNextBookmark);
				AppModel.proxies.branch.removeEventListener(BookmarkEvent.STASH_LIST_READ, onStoredBookmarkReady);
				dispatchEvent(new BookmarkEvent(BookmarkEvent.BOOKMARKS_LOADED, _bookmarks));
				dispatchActiveBookmark();
			}
		}
		
		private function dispatchActiveBookmark():void
		{
			var ab:Bookmark; // active bookmark //
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i].active == true) ab = _bookmarks[i];
			if (ab != null) dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, ab));
		}					
		
	}
	
}
