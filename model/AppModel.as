package model {

	import events.BookmarkEvent;
	import model.db.AppDatabase;
	import model.db.AppSettings;
	import model.proxies.AppProxies;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import system.PreloadManager;
	import system.UpdateManager;
	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {

		private static var _engine			:AppEngine = new AppEngine();	
		private static var _proxies			:AppProxies = new AppProxies();		
		private static var _database		:AppDatabase = new AppDatabase();
		private static var _settings		:AppSettings = new AppSettings();
		private static var _updater			:UpdateManager = new UpdateManager();
		private static var _preloader		:PreloadManager = new PreloadManager();
		private static var _bookmark		:Bookmark; // the active bookmark //

		public function AppModel() 
		{
			_preloader.initialize();
			_proxies.update.initialize();
		}
		
		static public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_database.setActiveBookmark(_bookmark.label);
		// TODO remove argument, all listeners should just access AppModel.bookmark	
			_engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, _bookmark));
		}
		
	// public getters //
		
		static public function get bookmark()	:Bookmark 		{ return _bookmark; }
		static public function get branch()		:Branch 		{ return _bookmark.branch; }
		static public function get engine()		:AppEngine 		{ return _engine; }
		static public function get proxies()	:AppProxies 	{ return _proxies; }
		static public function get database()	:AppDatabase 	{ return _database; }
		static public function get settings()	:AppSettings 	{ return _settings; }
		static public function get updater()	:UpdateManager 	{ return _updater; }
		
	}
	
}
