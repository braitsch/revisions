package model {
	import model.git.Configurator;
	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.db.AppDataBase;
	import model.git.GitInstaller;
	import model.git.RepositoryEditor;
	import model.git.RepositoryHistory;
	import model.git.RepositoryStatus;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _instance	:AppModel;
		private static var _bookmark	:Bookmark;
		private static var _status 		:RepositoryStatus = new RepositoryStatus();
		private static var _history		:RepositoryHistory = new RepositoryHistory();					private static var _editor		:RepositoryEditor = new RepositoryEditor();
		private static var _database	:AppDataBase = new AppDataBase();		private static var _config		:Configurator = new Configurator();
		private static var _installer	:GitInstaller = new GitInstaller();

		public function AppModel() 
		{
			_instance = this;
			_installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);						_editor.addEventListener(RepositoryEvent.REFRESH_STATUS, onRefreshStatus);						_editor.addEventListener(RepositoryEvent.REFRESH_HISTORY, onRefreshHistory);
			_history.addEventListener(RepositoryEvent.BRANCH_CHANGED, onRefreshStatus);			
		}		

		static public function set bookmark(b:Bookmark):void
		{
		// set only from BookmarkView //	
			_bookmark = b;
			_status.bookmark = _history.bookmark = _editor.bookmark = _database.bookmark = _bookmark;
			_instance.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SELECTED, b));
		}	
		
		static public function get bookmark():Bookmark
		{
			return _bookmark;
		}	
		
		static public function getInstance():AppModel
		{
			return _instance;
		}						

		static public function get status():RepositoryStatus
		{
			return _status;
		}			
		
		static public function get history():RepositoryHistory
		{
			return _history;
		}									
		
		static public function get editor():RepositoryEditor
		{
			return _editor;
		}	
		
		static public function get config():Configurator
		{
			return _config;
		}		
		
		static public function get installer():GitInstaller
		{
			return _installer;
		}	
		
		static public function get database():AppDataBase
		{
			return _database;
		}
		
	// event handlers //	
	
		private function onGitAvailable(e:InstallEvent):void 
		{
			_database.init();
		}		
		
		private function onRefreshStatus(e:RepositoryEvent):void 
		{
			_status.getStatus();	
		}
		
		private function onRefreshHistory(e:RepositoryEvent):void 
		{
			_history.getHistory();
		}
		
	}
	
}
