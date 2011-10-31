package model {

	import events.AppEvent;
	import model.db.AppDatabase;
	import model.proxies.AppProxies;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Repository;
	import system.AppSettings;
	import system.UpdateManager;
	import view.windows.modals.system.Alert;
	import view.windows.modals.system.ResolveMerge;
	import flash.events.EventDispatcher;

	public class AppModel extends EventDispatcher {

		private static var _engine			:AppEngine = new AppEngine();	
		private static var _proxies			:AppProxies = new AppProxies();		
		private static var _database		:AppDatabase = new AppDatabase();
		private static var _settings		:AppSettings = new AppSettings();
		private static var _updater			:UpdateManager = new UpdateManager();
		private static var _merge			:ResolveMerge = new ResolveMerge();
		private static var _bookmark		:Bookmark; // active bookmark //

		public function AppModel() 
		{
			_proxies.status.initialize();
		}
		
		static public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			if (_bookmark) {
				_database.setActiveBookmark(_bookmark.label);
				dispatch(AppEvent.BOOKMARK_SELECTED);
			}
		}
		
	// public getters //
		
		static public function get bookmark()	:Bookmark 		{ return _bookmark; }
		static public function get branch()		:Branch 		{ return _bookmark.branch; }
		static public function get repository()	:Repository 	{ return _bookmark.remote; }
		static public function get engine()		:AppEngine 		{ return _engine; 	}
		static public function get proxies()	:AppProxies 	{ return _proxies; 	}
		static public function get database()	:AppDatabase 	{ return _database; }
		static public function get settings()	:AppSettings 	{ return _settings; }
		static public function get updater()	:UpdateManager 	{ return _updater; 	}
		static public function get merge()		:ResolveMerge	{ return _merge; 	}
		
		static public function alert(a:Alert):void
		{
			_engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, a));
		}
		
		static public function dispatch(s:String, o:Object = null):void
		{
			_engine.dispatchEvent(new AppEvent(s, o));			
		}
		
		static public function showLoader(m:String, p:Boolean = false):void
		{
			_engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:m, prog:p}));
		}
		
		static public function hideLoader():void
		{
			_engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}
		
	}
	
}
