package model {

	import events.BookmarkEvent;
	import events.DataBaseEvent;
	import flash.events.EventDispatcher;
	import model.db.AppDatabase;
	import model.db.AppSettings;
	import model.proxies.AppProxies;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import system.UpdateManager;

	public class AppModel extends EventDispatcher {

		private static var _engine			:AppEngine = new AppEngine();	
		private static var _proxies			:AppProxies = new AppProxies();		
		private static var _database		:AppDatabase = new AppDatabase();
		private static var _settings		:AppSettings = new AppSettings();
		private static var _updater			:UpdateManager = new UpdateManager();
		private static var _bookmark		:Bookmark; // the active bookmark //

		public function AppModel() 
		{
			_engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSet);
			_database.addEventListener(DataBaseEvent.BOOKMARKS_READ, onBookmarksRead);
		}
		
		static public function onBookmarkSet(e:BookmarkEvent):void
		{
			_bookmark = e.data as Bookmark;
			_database.setActiveBookmark(_bookmark.label);
			AppModel.proxies.status.getStatus();
			AppModel.proxies.history.getSummary();
		}
		
	// public getters //
		
		static public function get bookmark()	:Bookmark 		{ return _bookmark; }
		static public function get branch()		:Branch 		{ return _bookmark.branch; }
		static public function get engine()		:AppEngine 		{ return _engine; }	
		static public function get proxies()	:AppProxies 	{ return _proxies; }																			
		static public function get database()	:AppDatabase 	{ return _database; }
		static public function get settings()	:AppSettings 	{ return _settings; }
		static public function get updater()	:UpdateManager 	{ return _updater; }				
		
	// event handlers //	
	
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
