package model {
	import events.InstallEvent;

	import model.db.AppDatabase;
	import model.git.repo.AppProxies;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _proxies		:AppProxies = new AppProxies();		
		private static var _database	:AppDatabase = new AppDatabase();
		private static var _bookmarks	:BookmarkModel = new BookmarkModel(_proxies, _database);	

		public function AppModel() 
		{
			_proxies.installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);			
		}
		
		static public function set bookmark(b:Bookmark):void
		{
			_proxies.bookmark = b;
			_bookmarks.bookmark = b;
		}	
		
		static public function get bookmark():Bookmark
		{
			return _bookmarks.bookmark;	
		}
		
		static public function get branch():Branch
		{
			return _bookmarks.bookmark.branch;	
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
