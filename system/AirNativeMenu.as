package system {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.ErrorType;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Keyboard;
 
 
    public class AirNativeMenu extends Sprite 
    { 
    	
       	private static var _stage		:Stage;
       	private static var _appMenu		:NativeMenu;
       	private static var _accounts	:NativeMenuItem;
       	private static var _github		:NativeMenuItem = new NativeMenuItem('My Github');
       	private static var _beanstalk	:NativeMenuItem = new NativeMenuItem('My Beanstalk');
       	private static var _linkAcct	:NativeMenuItem = new NativeMenuItem('Link To Account');
       	private static var _newBkmk		:NativeMenuItem = new NativeMenuItem('New Bookmark');
       	private static var _commit		:NativeMenuItem = new NativeMenuItem('New Commit');
       	private static var _aboutGit	:NativeMenuItem = new NativeMenuItem('About Git');
       	private static var _updateApp	:NativeMenuItem = new NativeMenuItem('Check For Updates');
                     
        public static function initialize(s:Stage):void
        {
        	_stage = s;
            _appMenu = NativeApplication.nativeApplication.menu;
            addLocalOptions();
            addAccountOptions();
            setKeyEquivalents();
            AppModel.engine.addEventListener(BookmarkEvent.MODIFIED_RECEIVED, enableSaveCommit);
		}

		private static function setKeyEquivalents():void
		{
       		_newBkmk.keyEquivalent = 'n';
       		_newBkmk.keyEquivalentModifiers = [Keyboard.COMMAND];
       		_commit.keyEquivalent = 's';
       		_commit.keyEquivalentModifiers = [Keyboard.COMMAND];
       		_github.keyEquivalent = 'g';
       		_github.keyEquivalentModifiers = [Keyboard.COMMAND];
       		_beanstalk.keyEquivalent = 'b';
       		_beanstalk.keyEquivalentModifiers = [Keyboard.COMMAND];
       		_linkAcct.keyEquivalent = 'u';
       		_linkAcct.keyEquivalentModifiers = [Keyboard.COMMAND];
		}

		private static function addLocalOptions():void
		{
		// file menu //	
            var f:NativeMenuItem = getMenuByName('File');
            	f.submenu.addItem(_newBkmk);
            	f.submenu.addItem(_commit);
            _commit.addEventListener(Event.SELECT, onOptionSelected);            
            _newBkmk.addEventListener(Event.SELECT, onOptionSelected);
		// main menu //
            var m:NativeMenuItem = getMenuByName('adl') || getMenuByName('Revisions');
         	   	m.submenu.addItemAt(_aboutGit, 1);
				m.submenu.addItemAt(_updateApp, 2);
            _aboutGit.addEventListener(Event.SELECT, onOptionSelected);
            _updateApp.addEventListener(Event.SELECT, onOptionSelected);
		}
		
		private static function addAccountOptions():void
		{
			_accounts = _appMenu.addSubmenu(new NativeMenu(), "Accounts");
			_accounts.submenu.addItem(_github);
			_accounts.submenu.addItem(_beanstalk);
			_accounts.submenu.addItem(_linkAcct);
			_github.addEventListener(Event.SELECT, onOptionSelected);
			_beanstalk.addEventListener(Event.SELECT, onOptionSelected);
			_linkAcct.addEventListener(Event.SELECT, onOptionSelected);
			
		}
		
		private static function getMenuByName(s:String):NativeMenuItem
		{
            for (var i:int = 0; i < _appMenu.items.length; i++) if (_appMenu.items[i].label == s) return _appMenu.items[i];
            return null;
		}
		
		private static function enableSaveCommit(e:BookmarkEvent):void
		{
			_commit.enabled = AppModel.bookmark.branch.isModified;
		}		
                 
        private static function onOptionSelected(e:Event):void 
        { 
        	 switch(e.target){
        	 	case _newBkmk	: 
        	 		_stage.dispatchEvent(new UIEvent(UIEvent.ADD_BOOKMARK));
        	 	break;
        	 	case _commit	: 
        	 		if (AppModel.bookmark.branch.isModified) _stage.dispatchEvent(new UIEvent(UIEvent.COMMIT));
        	 	break;        	 	
        	 	case _aboutGit : 
        	 		_stage.dispatchEvent(new UIEvent(UIEvent.ABOUT_GIT));
        	 	break;  
        	 	case _github : 
        	 		onGitHubClick();
        	 	break;   
        	 	case _beanstalk : 
        	 		onBeanstalkClick();
        	 	break;
        	 	case _linkAcct : 
        	 		_stage.dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_ACCOUNT));
        	 	break;        	 	           	 	       	 	      	 	
        	 	case _updateApp	: 
					onUpdateAppClick();
        	 	break;
        	 }
		}
		
		private static function onGitHubClick():void
		{
			if (Hosts.github.loggedIn){
        	 	_stage.dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
			}	else{
				_stage.dispatchEvent(new UIEvent(UIEvent.GITHUB_LOGIN, UIEvent.GITHUB_HOME));
			}			
		}
		
		private static function onBeanstalkClick():void
		{
			if (Hosts.beanstalk.loggedIn){
        	 	_stage.dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
			}	else{
				_stage.dispatchEvent(new UIEvent(UIEvent.BEANSTALK_LOGIN, UIEvent.BEANSTALK_HOME));
			}							
		}
		
		private static function onUpdateAppClick():void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, true);
	 		AppModel.updater.addEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
	 		AppModel.updater.addEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);
	 		AppModel.updater.checkForUpdate();			
		}

		private static function onUpdateUnavailable(e:AppEvent):void
		{
			AppModel.updater.removeEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);			
			AppModel.updater.removeEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);			
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, ErrorType.NO_CONNECTION));			
		}

		private static function onAppUpToDate(e:AppEvent):void
		{
			AppModel.updater.removeEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);			
			AppModel.updater.removeEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateUnavailable);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Revisions '+e.data+' is up to date'));
		}
      
    } 
    
} 