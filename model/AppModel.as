package model {
	import events.DataBaseEvent;
	import events.InstallEvent;

	import model.db.AppDataBase;
	import model.git.Configurator;
	import model.git.GitInstaller;
	import model.git.RepositoryModel;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _database	:AppDataBase = new AppDataBase();
		private static var _repos		:RepositoryModel = new RepositoryModel();		
		private static var _config		:Configurator = new Configurator();
		private static var _installer	:GitInstaller = new GitInstaller();

		public function AppModel() 
		{
			_database.addEventListener(DataBaseEvent.REPOSITORIES, onRepositories);
			_installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);
		}
		
	// shortcuts -- need to be implemented //	
		
		static public function get bookmark():Bookmark
		{
			return _repos.bookmark;	
		}
		
		static public function get branch():Branch
		{
			return _repos.bookmark.branch;	
		}
		
	// public getters //			

		static public function get repos():RepositoryModel
		{
			return _repos;
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
		
		private function onRepositories(e:DataBaseEvent):void 
		{
			_repos.repositories = e.data as Array;	
		}	
		
	}
	
}
