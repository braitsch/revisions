package model {
	import events.DataBaseEvent;
	import events.InstallEvent;

	import model.db.AppDataBase;
	import model.git.core.Configurator;
	import model.git.core.Installer;
	import model.git.repo.RepositoryProxy;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _database	:AppDataBase = new AppDataBase();
		private static var _proxy		:RepositoryProxy = new RepositoryProxy();		
		private static var _config		:Configurator = new Configurator();
		private static var _installer	:Installer = new Installer();

		public function AppModel() 
		{
			_database.addEventListener(DataBaseEvent.REPOSITORIES, onRepositories);
			_installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);
		}
		
	// shortcuts -- need to be implemented //	
		
		static public function get bookmark():Bookmark
		{
			return _proxy.bookmark;	
		}
		
		static public function get branch():Branch
		{
			return _proxy.bookmark.branch;	
		}
		
	// public getters //			

		static public function get proxy():RepositoryProxy
		{
			return _proxy;
		}																			
		
		static public function get config():Configurator
		{
			return _config;
		}		
		
		static public function get installer():Installer
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
			_proxy.repositories = e.data as Array;	
		}	
		
	}
	
}
