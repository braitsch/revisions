package model {
	import events.RepositoryEvent;

	import model.db.GitMeDataBase;
	import model.git.GitInstaller;
	import model.git.RepositoryEditor;
	import model.git.RepositoryHistory;
	import model.git.RepositoryStatus;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _installer	:GitInstaller = new GitInstaller();		private static var _editor		:RepositoryEditor = new RepositoryEditor();
		private static var _status 		:RepositoryStatus = new RepositoryStatus();
		private static var _history		:RepositoryHistory = new RepositoryHistory();
		private static var _database	:GitMeDataBase = new GitMeDataBase();
		private static var _instance	:AppModel;

		public function AppModel() 
		{
			_instance = this;
			_installer.checkGitIsInstalled();
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_editor.bookmark = b;			_status.bookmark = b;			_history.bookmark = b;
			_database.setActiveBookmark(b.label);				
			dispatchEvent(new RepositoryEvent(RepositoryEvent.SET_BOOKMARK, b));
		}			

	//TODO this needs to be renamed to installer...
		static public function get core():GitInstaller
		{
			return _installer;
		}	
		
		static public function get editor():RepositoryEditor
		{
			return _editor;
		}						
		
		static public function get status():RepositoryStatus
		{
			return _status;
		}		
		
		static public function get history():RepositoryHistory
		{
			return _history;
		}	
		
		static public function get database():GitMeDataBase
		{
			return _database;
		}

		static public function getInstance():AppModel
		{
			return _instance;
		}
		
	}
	
}
