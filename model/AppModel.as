package model {
	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.db.AppDataBase;
	import model.git.GitInstaller;
	import model.git.RepositoryEditor;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _instance	:AppModel;
		private static var _bookmark	:Bookmark;		private static var _editor		:RepositoryEditor = new RepositoryEditor();
		private static var _database	:AppDataBase = new AppDataBase();
		private static var _installer	:GitInstaller = new GitInstaller();

		public function AppModel() 
		{
			_instance = this;
			_installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);			
		}

		private function onGitAvailable(e:InstallEvent):void 
		{
			_database.init();
		}

		static public function set bookmark(b:Bookmark):void
		{
		// set only from BookmarkView //	
			_bookmark = b;
			_editor.bookmark = _database.bookmark = _bookmark;			_instance.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SELECTED, b));
		}	
		
		static public function get bookmark():Bookmark
		{
			return _bookmark;
		}				

		static public function get installer():GitInstaller
		{
			return _installer;
		}	
		
		static public function get editor():RepositoryEditor
		{
			return _editor;
		}							
		
		static public function get database():AppDataBase
		{
			return _database;
		}

		static public function getInstance():AppModel
		{
			return _instance;
		}
		
	}
	
}
