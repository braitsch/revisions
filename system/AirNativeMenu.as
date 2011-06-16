package system {

	import events.InstallEvent;
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
    	
       	private static var _menu	:NativeMenu;
       	private static var _file	:NativeMenuItem;
       	private static var _main	:NativeMenuItem;
       	private static var _new		:NativeMenuItem = new NativeMenuItem('New Bookmark');
       	private static var _update	:NativeMenuItem = new NativeMenuItem('Check For Updates');
       	private static var _stage	:Stage;
                     
        public static function initialize(s:Stage):void
        {
        	_stage = s;
            _menu = NativeApplication.nativeApplication.menu;
            _file = getMenuByName('File');
            _new.addEventListener(Event.SELECT, onOptionSelected);
            _file.submenu.addItem(_new);
            _main = getMenuByName('adl');
            if (!_main) _main = getMenuByName('Revisions');
            _update.addEventListener(Event.SELECT, onOptionSelected);
            _main.submenu.addItemAt(_update, 1);
		}

		private static function getMenuByName(s:String):NativeMenuItem
		{
            for (var i:int = 0; i < _menu.items.length; i++) if (_menu.items[i].label == s) return _menu.items[i];
            return null;
		}
                 
        private static function onOptionSelected(e:Event):void 
        { 
        	 switch(e.target){
        	 	case _new		: 
        	 		_stage.dispatchEvent(new UIEvent(UIEvent.ADD_BOOKMARK));	
        	 	break;
        	 	case _update	: 
					AppSettings.setSetting(AppSettings.IGNORE_UPDATES, 'false');
        	 		AppModel.updater.addEventListener(InstallEvent.APP_UP_TO_DATE, onUpToDate);
        	 		AppModel.updater.checkForUpdate();
        	 	break;	
        	 }
           
		}

		private static function onUpToDate(e:InstallEvent):void
		{
			_stage.dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'Revisions '+e.data+' is up to date'));
		}
      
    } 
    
} 