package model {

	import events.AppEvent;
	import events.DataBaseEvent;
	import model.vo.Bookmark;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	// class reposonsible for adding and removing bookmarks from the application //

	public class AppEngine extends EventDispatcher {
		
		private static var _index			:uint = 0;
		private static var _bookmark		:Bookmark;
		private static var _broken			:Vector.<Bookmark> = new Vector.<Bookmark>();
		private static var _bookmarks		:Vector.<Bookmark> = new Vector.<Bookmark>();

	// expose bookmarks to check against duplicates being added //
			
		static public function get bookmarks():Vector.<Bookmark> { return _bookmarks; }
		
	// ---------- ADDING NEW BOOKMARKS ---------- //

		public function addBookmark(b:Bookmark):void
		{
			_bookmark = b;
			AppModel.proxies.status.locked = true;
			AppModel.proxies.creator.initBookmark(_bookmark);
			addEventListener(AppEvent.INITIALIZED, readRepository);		
		}
		
		private function readRepository(e:AppEvent):void
		{
			removeEventListener(AppEvent.INITIALIZED, readRepository);
			AppModel.proxies.reader.getRepositoryInfo(_bookmark);
			addEventListener(AppEvent.REPOSITORY_READY, addBkmkToDatabase);
		}
		
		private function addBkmkToDatabase(e:AppEvent):void
		{
			removeEventListener(AppEvent.REPOSITORY_READY, addBkmkToDatabase);
			AppModel.database.addRepository(_bookmark);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_ADDED, onAddedToDatabase);			
		}

		private function onAddedToDatabase(e:DataBaseEvent):void 
		{
			_bookmarks.push(_bookmark);
			AppModel.dispatch(AppEvent.HIDE_LOADER, .25);
			AppModel.dispatch(AppEvent.BOOKMARK_ADDED, _bookmark);
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_ADDED, onAddedToDatabase);
			dispatchActiveBookmark();
		}

	// ---------- DELETING BOOKMARKS ---------- //

		public function deleteBookmark(bkmk:Bookmark, killGit:Boolean, killFiles:Boolean):void
		{
			_bookmark = bkmk;
			AppModel.proxies.status.locked = true;
			if (!killGit && !killFiles){
				removeFromBkmkView();
			}	else{
				addEventListener(AppEvent.FILES_DELETED, removeFromBkmkView);
				AppModel.proxies.creator.killBookmark(_bookmark, killGit, killFiles);		
			}
		}
		
		private function removeFromBkmkView(e:AppEvent = null):void
		{
			removeEventListener(AppEvent.FILES_DELETED, removeFromBkmkView);
			AppModel.database.deleteRepository(_bookmark.label);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_DELETED, onRemovedFromDatabase);
		}
			
		private function onRemovedFromDatabase(e:DataBaseEvent):void 
		{
			AppModel.dispatch(AppEvent.BOOKMARK_DELETED, _bookmark);
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_DELETED, onRemovedFromDatabase);
			deleteAndSetNewActiveBookmark(e.data as Array);
		}
		
		private function deleteAndSetNewActiveBookmark(a:Array):void
		{
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i] == _bookmark) _bookmarks.splice(i, 1);
			for (var j:int = 0; j < a.length; j++) if (a[j].active == 1) _bookmark = _bookmarks[j];
			if (_broken.length > 0) {
				_broken.splice(0, 1);
				if (_broken.length == 0) {
					initializeBookmarks();
				}	else{
					AppModel.dispatch(AppEvent.PATH_ERROR, _broken[0]);
				}
			}	else if (_bookmarks.length){
				dispatchActiveBookmark();	
			}	else{
				AppModel.bookmark = null;
				AppModel.dispatch(AppEvent.NO_BOOKMARKS);
			}			
		}
		
	// ---------- GENERATE FROM DATABASE ---------- //
		
		public function initialize(a:Array):void 
		{
			buildBkmksFromDatabase(a);
			if (_bookmarks.length == 0){
				AppModel.dispatch(AppEvent.NO_BOOKMARKS);	
			}	else{
				checkForBrokenPaths();
				if (_broken.length == 0) {
					initializeBookmarks();
				}	else{
					AppModel.dispatch(AppEvent.PATH_ERROR, _broken[0]);
					addEventListener(AppEvent.BOOKMARK_REPAIRED, onBookmarkRepaired);
				}
			}
		}

		private function onBookmarkRepaired(e:AppEvent):void
		{
			if (_broken.length > 0) {
				_broken.splice(0, 1);
				if (_broken.length == 0) {
					initializeBookmarks();
					removeEventListener(AppEvent.BOOKMARK_REPAIRED, onBookmarkRepaired);
				}	else {
					AppModel.dispatch(AppEvent.PATH_ERROR, _broken[0]);
				}
			}
		}

		private function buildBkmksFromDatabase(a:Array):void
		{
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
			for (var i:int = 0; i < _bookmarks.length; i++) if (!_bookmarks[i].exists) _broken.push(_bookmarks[i]);			
		}
		
		private function initializeBookmarks():void
		{
			AppModel.showLoader('Initalizing Bookmarks');
			AppModel.proxies.reader.getRepositoryInfo(_bookmarks[_index]);
			addEventListener(AppEvent.REPOSITORY_READY, onRepositoryReady);
		}

		private function onRepositoryReady(e:AppEvent):void 
		{
			if (++_index == _bookmarks.length){
				onAllBookmarksParsed();
			}	else{
				AppModel.proxies.reader.getRepositoryInfo(_bookmarks[_index]);	
			}
		}
		
		private function onAllBookmarksParsed():void
		{
			setTimeout(dispatchActiveBookmark, 500);
			AppModel.dispatch(AppEvent.HIDE_LOADER, .5);
			AppModel.dispatch(AppEvent.BOOKMARKS_LOADED, _bookmarks);
			removeEventListener(AppEvent.REPOSITORY_READY, onRepositoryReady);
		}
		
		private function dispatchActiveBookmark():void
		{
		// on database error, default to the first bookmark //	
			if (_bookmark == null) _bookmark = _bookmarks[0];
			AppModel.bookmark = _bookmark;
			AppModel.proxies.status.locked = false;
		}

	}
	
}
