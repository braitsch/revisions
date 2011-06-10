package model {

	import events.BookmarkEvent;
	import events.DataBaseEvent;
	import events.InstallEvent;
	import model.db.AppDatabase;
	import model.db.AppSettings;
	import model.proxies.AppProxies;
	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {

		private static var _engine			:AppEngine = new AppEngine();	
		private static var _proxies			:AppProxies = new AppProxies();		
		private static var _database		:AppDatabase = new AppDatabase();
		private static var _settings		:AppSettings = new AppSettings();
		private static var _bookmark		:Bookmark; // the active bookmark //
		
		private static var _gitAvailable	:Boolean;		private static var _databaseReady	:Boolean;

		public function AppModel() 
		{
			_engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSet);
			_database.addEventListener(DataBaseEvent.BOOKMARKS_READ, onBookmarksRead);
			_database.addEventListener(DataBaseEvent.DATABASE_READY, onDatabaseReady);
			_proxies.config.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);
		}
		
		static public function onBookmarkSet(e:BookmarkEvent):void
		{
			_bookmark = e.data as Bookmark;
			_database.setActiveBookmark(_bookmark.label);
			AppModel.proxies.status.getStatus();
			AppModel.proxies.history.getSummaryDetails();
//			if (_bookmark.branch.history){
//				AppModel.proxies.status.getStatus();
//			}	else{
//				AppModel.proxies.history.getHistory();	
//			}
		}
		
		static public function get bookmark():Bookmark
		{
			return _bookmark;	
		}
		
		static public function get branch():Branch
		{
			return _bookmark.branch;	
		}
		
	// model object //	
	
		static public function get engine():AppEngine
		{
			return _engine;
		}	
		
		static public function get proxies():AppProxies
		{
			return _proxies;
		}																			
		
		static public function get database():AppDatabase
		{
			return _database;
		}
		
		static public function get settings():AppSettings
		{
			return _settings;
		}		
		
	// event handlers //	
	
		private function onGitAvailable(e:InstallEvent):void 
		{
			_gitAvailable = true;
			if (_databaseReady) _database.init();
		}
		
		private function onDatabaseReady(e:DataBaseEvent):void
		{
			_databaseReady = true;
			if (_gitAvailable) _database.init();			
		}		
		
		private function onBookmarksRead(e:DataBaseEvent):void
		{
			var a:Array = e.data as Array;
			if (a.length > 0) {
			// pass the db records to the bookmark engine //	
				_engine.generateBookmarks(a);
			}	else{
				_engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.NO_BOOKMARKS));
			}
		}
		
	}
	
}
