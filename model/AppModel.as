package model {
	import events.DataBaseEvent;
	import events.InstallEvent;

	import model.db.AppDataBase;
	import model.git.Configurator;
	import model.git.GitInstaller;
	import model.git.RepositoryModel;

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
	
		private function onRepositories(e:DataBaseEvent):void 
		{
			_repos.repositories = e.data as Array;	
		}	
	
		private function onGitAvailable(e:InstallEvent):void 
		{
			_database.init();
		}			
		
	}
	
}
