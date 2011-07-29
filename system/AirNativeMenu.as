package system {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.db.AppSettings;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
 
 
    public class AirNativeMenu extends Sprite 
    { 
    	
       	private static var _stage		:Stage;
       	private static var _appMenu		:NativeMenu;
       	private static var _remote		:NativeMenuItem;
       	private static var _github		:NativeMenuItem;
       	private static var _beanstalk	:NativeMenuItem;
       	private static var _newBkmk		:NativeMenuItem = new NativeMenuItem('New Bookmark');
       	private static var _aboutGit	:NativeMenuItem = new NativeMenuItem('About Git');
       	private static var _updateApp	:NativeMenuItem = new NativeMenuItem('Check For Updates');
                     
        public static function initialize(s:Stage):void
        {
        	_stage = s;
            _appMenu = NativeApplication.nativeApplication.menu;
            addLocalOptions();
            AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onRemoteReady);
		}
		
		private static function addLocalOptions():void
		{
		// file menu //	
            var f:NativeMenuItem = getMenuByName('File');
            f.submenu.addItem(_newBkmk);
            _newBkmk.addEventListener(Event.SELECT, onOptionSelected);
		// main menu //
            var m:NativeMenuItem = getMenuByName('adl');
            if (!m) m = getMenuByName('Revisions');
            m.submenu.addItemAt(_aboutGit, 1);
            m.submenu.addItemAt(_updateApp, 2);
            _aboutGit.addEventListener(Event.SELECT, onOptionSelected);
            _updateApp.addEventListener(Event.SELECT, onOptionSelected);
		}
		
		private static function onRemoteReady(e:AppEvent):void
		{
			if (_remote == null) _remote = _appMenu.addSubmenu(new NativeMenu(), "Remote");
			addRemoteOption(e.data as RemoteAccount);
		}
		
		private static function addRemoteOption(ra:RemoteAccount):void
		{
			switch(ra.type){
				case RemoteAccount.GITHUB :
					_github = new NativeMenuItem('My Github');
					_remote.submenu.addItem(_github);
					_github.addEventListener(Event.SELECT, onOptionSelected);
				break;	
				case RemoteAccount.BEANSTALK:
					_beanstalk = new NativeMenuItem('My Beanstalk');				
					_remote.submenu.addItem(_beanstalk);
					_beanstalk.addEventListener(Event.SELECT, onOptionSelected);
				break;					
			}
		}

		private static function getMenuByName(s:String):NativeMenuItem
		{
            for (var i:int = 0; i < _appMenu.items.length; i++) if (_appMenu.items[i].label == s) return _appMenu.items[i];
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
        	 	case _github : 
        	 		onGitHubClick();
        	 	break;          	 	      	 	
        	 	case _updateApp	: 
					AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, true);
        	 		AppModel.updater.addEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
        	 		AppModel.updater.addEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);
        	 		AppModel.updater.checkForUpdate();
        	 	break;	       	 	
        	 }
		}
		
		private static function onGitHubClick():void
		{
			if (AccountManager.github){
        	 	_stage.dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
			}	else{
				_stage.dispatchEvent(new UIEvent(UIEvent.REMOTE_LOGIN, {type:RemoteAccount.GITHUB, event:UIEvent.GITHUB_HOME}));
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