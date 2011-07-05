package system {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.db.AppSettings;
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
 
 
    public class AirNativeMenu extends Sprite 
    { 
    	
       	private static var _menu		:NativeMenu;
       	private static var _file		:NativeMenuItem;
       	private static var _main		:NativeMenuItem;
       	private static var _newBkmk		:NativeMenuItem = new NativeMenuItem('New Bookmark');
       	private static var _aboutGit	:NativeMenuItem = new NativeMenuItem('About Git');
       	private static var _updateApp	:NativeMenuItem = new NativeMenuItem('Check For Updates');
       	private static var _stage		:Stage;
                     
        public static function initialize(s:Stage):void
        {
        	_stage = s;
            _menu = NativeApplication.nativeApplication.menu;
            _file = getMenuByName('File');
            _newBkmk.addEventListener(Event.SELECT, onOptionSelected);
            _file.submenu.addItem(_newBkmk);
            _main = getMenuByName('adl');
            if (!_main) _main = getMenuByName('Revisions');
            _updateApp.addEventListener(Event.SELECT, onOptionSelected);
            _aboutGit.addEventListener(Event.SELECT, onOptionSelected);
            _main.submenu.addItemAt(_aboutGit, 1);
            _main.submenu.addItemAt(_updateApp, 2);
		}

		private static function getMenuByName(s:String):NativeMenuItem
		{
            for (var i:int = 0; i < _menu.items.length; i++) if (_menu.items[i].label == s) return _menu.items[i];
            return null;
		}
                 
        private static function onOptionSelected(e:Event):void 
        { 
        	 switch(e.target){
        	 	case _newBkmk	: 
        	 		_stage.dispatchEvent(new UIEvent(UIEvent.ADD_BOOKMARK));	
        	 	break;
        	 	case _aboutGit : 
        	 		_stage.dispatchEvent(new UIEvent(UIEvent.ABOUT_GIT));
        	 	break;        	 	
        	 	case _updateApp	: 
					AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, true);
        	 		AppModel.updater.addEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
        	 		AppModel.updater.addEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);
        	 		AppModel.updater.checkForUpdate();
        	 	break;	       	 	
        	 }
		}

		private static function onUpdateUnavailable(e:AppEvent):void
		{
			AppModel.updater.removeEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);			
			AppModel.updater.removeEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);			
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Update server unavailable.\nPlease check your internet connection'));			
		}

		private static function onAppUpToDate(e:AppEvent):void
		{
			AppModel.updater.removeEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);			
			AppModel.updater.removeEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Revisions '+e.data+' is up to date'));
		}
      
    } 
    
} 