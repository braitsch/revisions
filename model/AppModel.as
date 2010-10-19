package model {
	import events.DataBaseEvent;
	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.db.AppDatabase;
	import model.proxies.AppProxies;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {

		private static var _instance	:AppModel;		
		private static var _bookmark	:Bookmark; // the active bookmark //

		private static var _engine		:AppEngine = new AppEngine();	
		private static var _proxies		:AppProxies = new AppProxies();		
		private static var _database	:AppDatabase = new AppDatabase();

		public function AppModel() 
		{
			_instance = this;
			_proxies.installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);			
			_database.addEventListener(DataBaseEvent.BOOKMARKS_READ, _engine.generateBookmarks);	
		}
		
		static public function set bookmark(b:Bookmark):void
		{
			_bookmark = _proxies.bookmark = _database.bookmark = b;
			_instance.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));			
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
	
		static public function getInstance():AppModel
		{
			return _instance;
		}
		
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
		
	// event handlers //	
	
		private function onGitAvailable(e:InstallEvent):void 
		{
			_database.init();
		}
		
	}
	
}
