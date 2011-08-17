package model {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.DataBaseEvent;
	import model.vo.Bookmark;
	import flash.events.EventDispatcher;

	// class reposonsible for adding and removing bookmarks from the application //

	public class AppEngine extends EventDispatcher {
		
		private static var _index			:uint = 0;
		private static var _bookmark		:Bookmark;
		private static var _broken			:Vector.<Bookmark>;
		private static var _bookmarks		:Vector.<Bookmark>;

	// expose bookmarks to check against duplicates being added //
			
		static public function get bookmarks():Vector.<Bookmark> { return _bookmarks; }
		
	// ---------- ADDING NEW BOOKMARKS ---------- //

		public function addBookmark(b:Bookmark):void
		{
			_bookmark = b;
			AppModel.proxies.init.initBookmark(_bookmark);
			AppModel.proxies.init.addEventListener(BookmarkEvent.INITIALIZED, readRepository);		
		}
		
		private function readRepository(e:BookmarkEvent):void
		{
			AppModel.proxies.init.removeEventListener(BookmarkEvent.INITIALIZED, readRepository);
			AppModel.proxies.reader.getRepositoryInfo(_bookmark);
			AppModel.proxies.reader.addEventListener(AppEvent.REPOSITORY_READY, addBkmkToDatabase);
		}
		
		private function addBkmkToDatabase(e:AppEvent):void
		{
			AppModel.proxies.reader.removeEventListener(AppEvent.REPOSITORY_READY, addBkmkToDatabase);
			AppModel.database.addRepository(_bookmark);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_ADDED, onAddedToDatabase);			
		}

		private function onAddedToDatabase(e:DataBaseEvent):void 
		{
			_bookmarks.push(_bookmark);
			dispatchEvent(new BookmarkEvent(BookmarkEvent.ADDED, _bookmark));
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_ADDED, onAddedToDatabase);
			dispatchActiveBookmark();
		}

	// ---------- DELETING BOOKMARKS ---------- //

		public function deleteBookmark(bkmk:Bookmark, killGit:Boolean, killFiles:Boolean):void
		{
			_bookmark = bkmk;
			if (!killGit && !killFiles){
				removeFromBkmkView();
			}	else{
				AppModel.proxies.init.addEventListener(AppEvent.FILES_DELETED, removeFromBkmkView);
				AppModel.proxies.init.killBookmark(_bookmark, killGit, killFiles);		
			}
		}
		
		private function removeFromBkmkView(e:AppEvent = null):void
		{
			AppModel.proxies.init.removeEventListener(AppEvent.FILES_DELETED, removeFromBkmkView);
			AppModel.database.deleteRepository(_bookmark.label);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_DELETED, onRemovedFromDatabase);
		}
			
		private function onRemovedFromDatabase(e:DataBaseEvent):void 
		{
			dispatchEvent(new BookmarkEvent(BookmarkEvent.DELETED, _bookmark));
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_DELETED, onRemovedFromDatabase);
			deleteAndSetNewActiveBookmark(e.data as Array);
		}
		
		private function deleteAndSetNewActiveBookmark(a:Array):void
		{
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i] == _bookmark) _bookmarks.splice(i, 1);
			for (var j:int = 0; j < a.length; j++) if (a[j].active == 1) _bookmark = _bookmarks[j];
			if (_broken.length == 0) {
				if (_bookmarks.length > 0) {
					dispatchActiveBookmark();
				}	else{
					dispatchEvent(new BookmarkEvent(BookmarkEvent.NO_BOOKMARKS));
				}		
			}			
		}
		
	// ---------- GENERATE FROM DATABASE ---------- //
		
		public function initialize(a:Array):void 
		{
			buildBkmksFromDatabase(a);
			if (_bookmarks.length == 0){
				dispatchEvent(new BookmarkEvent(BookmarkEvent.NO_BOOKMARKS));	
			}	else{
				checkForBrokenPaths();
				if (_broken.length == 0) {
					readBookmarkData();
				}	else{
					dispatchEvent(new BookmarkEvent(BookmarkEvent.PATH_ERROR, _broken[0]));
				}
			}
		}
		
		private function buildBkmksFromDatabase(a:Array):void
		{
			_bookmarks = new Vector.<Bookmark>();
			for (var i:int = 0; i < a.length; i++) {
				var o:Object = {
					label		:	a[i].label,
					type		:	a[i].type,
					path		:	a[i].path,
					active 		:	a[i].active,
					autosave	:	a[i].autosave};
				var b:Bookmark = new Bookmark(o);
				_bookmarks.push(b);
				if (b.active) _bookmark = b;
			}			
		}		
		
		private function checkForBrokenPaths():void
		{
			_broken = new Vector.<Bookmark>();
			for (var i:int = 0; i < _bookmarks.length; i++) if (!_bookmarks[i].exists) _broken.push(_bookmarks[i]);			
		}
		
	// called from everytime a bkmk is repaired //			
		public function getNextBrokenBookmark():Bookmark
		{
			if (_broken.length == 0) {
				return null;
			}	else{
				_broken.splice(0, 1);
				if (_broken.length == 0){
					readBookmarkData();
					return null;
				}	else{
					return _broken[0];
				}				
			}
		}
		
		private function readBookmarkData():void
		{
			dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Initalizing Bookmarks'}));
			AppModel.proxies.reader.getRepositoryInfo(_bookmarks[_index]);
			AppModel.proxies.reader.addEventListener(AppEvent.REPOSITORY_READY, onRepositoryReady);
		}

		private function onRepositoryReady(e:AppEvent):void 
		{
			if (++_index < _bookmarks.length){
				AppModel.proxies.reader.getRepositoryInfo(_bookmarks[_index]);	
			}	else{
				dispatchEvent(new BookmarkEvent(BookmarkEvent.LOADED, _bookmarks));
				dispatchActiveBookmark();
				AppModel.proxies.reader.removeEventListener(AppEvent.REPOSITORY_READY, onRepositoryReady);
			}
		}
		
		private function dispatchActiveBookmark():void
		{
		// on database error, default to the first bookmark //	
			if (_bookmark == null) _bookmark = _bookmarks[0];
			AppModel.bookmark = _bookmark;
		}

	}
	
}
