package model {
	import commands.UICommand;

	import events.DataBaseEvent;
	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.db.AppDataBase;
	import model.git.BranchEditor;
	import model.git.Configurator;
	import model.git.GitInstaller;
	import model.git.RepositoryEditor;
	import model.git.RepositoryHistory;
	import model.git.RepositoryStatus;

	import view.bookmarks.Bookmark;
	import view.layout.ListItem;

	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {
		
		private static var _instance	:AppModel;
		private static var _bookmark	:Bookmark;
		private static var _bookmarks	:Vector.<ListItem>;
				private static var _editor		:RepositoryEditor = new RepositoryEditor();
		private static var _branch		:BranchEditor = new BranchEditor();		private static var _status 		:RepositoryStatus = new RepositoryStatus();
		private static var _history		:RepositoryHistory = new RepositoryHistory();					private static var _config		:Configurator = new Configurator();
		private static var _installer	:GitInstaller = new GitInstaller();
		private static var _database	:AppDataBase = new AppDataBase();

		public function AppModel() 
		{
			_instance = this;
			_installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitAvailable);						_editor.addEventListener(RepositoryEvent.REFRESH_STATUS, onRefreshStatus);						_editor.addEventListener(RepositoryEvent.REFRESH_HISTORY, onRefreshHistory);
			_history.addEventListener(RepositoryEvent.BRANCH_CHANGED, onRefreshStatus);	
			_database.addEventListener(DataBaseEvent.REPOSITORIES, onRepositories);
			_branch.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady);
		}		

		static public function set bookmark(b:Bookmark):void
		{
		// set only from BookmarkView //	
			_bookmark = b;
			_status.bookmark = _history.bookmark = _bookmark;
			_editor.bookmark = _database.bookmark = _bookmark;
			_instance.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SELECTED, b));			
		}
		
		static public function get bookmark():Bookmark
		{
			return _bookmark;
		}
		
		static public function get bookmarks():Vector.<ListItem>
		{
			return _bookmarks;
		}				
		
		static public function getInstance():AppModel
		{
			return _instance;
		}														
		
		static public function get editor():RepositoryEditor
		{
			return _editor;
		}	
		
		static public function get branch():BranchEditor
		{
			return _branch;
		}	
		
		static public function get status():RepositoryStatus
		{
			return _status;
		}			
		
		static public function get history():RepositoryHistory
		{
			return _history;
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
		
		private function onRepositories(e:DataBaseEvent):void 
		{
			var d:Array = e.data as Array;
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			
			for (var i : int = 0; i < d.length; i++) {
				var b:Bookmark = new Bookmark(d[i].name, d[i].location, 'remote', d[i].active==1);
				if (b.file.exists) {
					v.push(b);
				}	else{
					dispatchEvent(new UICommand(UICommand.REPAIR_BOOKMARK, b));
					return;
				}
			}
			_bookmarks = v;
			_branch.getBranchesOfBookmarks();			
		}	
		
		private function onBookmarksReady(e:RepositoryEvent):void 
		{
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY));
			for (var i:int = 0; i < _bookmarks.length; i++) if (_bookmarks[i].active) AppModel.bookmark = _bookmarks[i] as Bookmark;
		}				
		
	}
	
}
