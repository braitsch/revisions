package model {
	import events.DataBaseEvent;
	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.db.AppDatabase;
	import model.proxies.AppProxies;

	
	

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {

		private static var _bookmark	:Bookmark; // the active bookmark //

		private static var _engine		:AppEngine = new AppEngine();	
		private static var _proxies		:AppProxies = new AppProxies();		
		private static var _database	:AppDatabase = new AppDatabase();

		public function AppModel() 
		{
			_engine.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkSet);
			_database.addEventListener(DataBaseEvent.BOOKMARKS_READ, onDatabaseReady);
			_proxies.installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);
		}

		static public function onBookmarkSet(e:RepositoryEvent):void
		{
			_bookmark = e.data as Bookmark;
			if (_bookmark == null) return; 
			_proxies.bookmark = _database.bookmark = _bookmark;
			AppModel.proxies.status.getStatusOfBranch(_bookmark.branch);
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
		
	// event handlers //	
	
		private function onGitAvailable(e:InstallEvent):void 
		{
			_database.init();
		}
		
		private function onDatabaseReady(e:DataBaseEvent):void
		{
			var a:Array = e.data as Array;
			if (a.length > 0) {
				_engine.generateBookmarks(a);
			}	else{
			// dispatch some event to the model manager //	
				trace('-- no bookmarks in database, show welcome screen --');
			}
		}
		
	}
	
}
