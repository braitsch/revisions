package view.windows.modals {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import system.FileUtils;
	import view.ui.Preloader;
	import view.windows.base.ParentWindow;
	import view.windows.commit.CommitParent;
	import view.windows.editor.BookmarkEditor;
	import view.windows.modals.git.GitAbout;
	import view.windows.modals.git.GitInstall;
	import view.windows.modals.git.GitUpgrade;
	import view.windows.modals.local.AddDragAndDrop;
	import view.windows.modals.local.AppExpired;
	import view.windows.modals.local.AppUpdate;
	import view.windows.modals.local.GlobalSettings;
	import view.windows.modals.local.NewBookmark;
	import view.windows.modals.local.NewCommit;
	import view.windows.modals.local.RepairBookmark;
	import view.windows.modals.local.VersionDetails;
	import view.windows.modals.local.WelcomeScreen;
	import view.windows.modals.login.PermissionsFailure;
	import view.windows.modals.system.Alert;
	import view.windows.modals.system.Message;
	import view.windows.upload.UploadWizard;
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;

	public class ModalManager extends Sprite {

		private static var _alert				:Alert;
		private static var _welcome				:WelcomeScreen = new WelcomeScreen();
		private static var _new					:NewBookmark = new NewBookmark();
		private static var _edit				:BookmarkEditor = new BookmarkEditor();
		private static var _repair				:RepairBookmark = new RepairBookmark();
		private static var _dragAndDrop			:AddDragAndDrop = new AddDragAndDrop();
		private static var _commit				:NewCommit = new NewCommit();
		private static var _commitOptions		:CommitParent = new CommitParent();
		private static var _details				:VersionDetails = new VersionDetails();
		private static var _settings			:GlobalSettings = new GlobalSettings();
		private static var _appUpdate			:AppUpdate = new AppUpdate();
		private static var _appExpired			:AppExpired = new AppExpired();
		private static var _gitAbout			:GitAbout = new GitAbout();
		private static var _gitInstall			:GitInstall = new GitInstall();
		private static var _gitUpgrade			:GitUpgrade = new GitUpgrade();
		private static var _uploadWizard		:UploadWizard = new UploadWizard();
		private static var _permissions			:PermissionsFailure = new PermissionsFailure();
		private static var _preloader			:Preloader = new Preloader();
		
	// windows that force user to make a decision - autoclose disabled //	
		private static var _stickies			:Vector.<ParentWindow> = new <ParentWindow>
				[ _repair, _appExpired, _appUpdate, _gitInstall, _gitUpgrade ];
				
		private static var _window				:ParentWindow;	// the active modal window //
		private static var _curtain				:ModalCurtain = new ModalCurtain();

		public function ModalManager()
		{
			addChild(_curtain);
			addChild(_preloader);			
			mouseEnabled = false;
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			AppModel.engine.addEventListener(AppEvent.SHOW_LOADER, showLoader);
			AppModel.engine.addEventListener(AppEvent.SHOW_ALERT, onShowAlert);
			AppModel.engine.addEventListener(AppEvent.HIDE_ALERT, onHideAlert);	
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, showWelcomeScreen);
			AppModel.engine.addEventListener(AppEvent.APP_EXPIRED, onAppExpired);
			AppModel.engine.addEventListener(AppEvent.PERMISSIONS_FAILURE, onPermissionsFailure);
			AppModel.updater.addEventListener(AppEvent.APP_UPDATE_AVAILABLE, promptToUpdate);
			AppModel.proxies.config.addEventListener(AppEvent.GIT_NOT_INSTALLED, installGit);
			AppModel.proxies.config.addEventListener(AppEvent.GIT_NEEDS_UPDATING, upgradeGit);
		}

		public function init(stage:Stage):void
		{
			stage.stageFocusRect = false;
			stage.addEventListener(UIEvent.DRAG_AND_DROP, onDragAndDrop);
			stage.addEventListener(UIEvent.ADD_BOOKMARK, onNewButtonClick);
			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);
			stage.addEventListener(UIEvent.COMMIT, addNewCommit);
			stage.addEventListener(UIEvent.COMMIT_OPTIONS, showCommitOptions);
			stage.addEventListener(UIEvent.SHOW_COMMIT, commitDetails);
			stage.addEventListener(UIEvent.ABOUT_GIT, onAboutGit);
			stage.addEventListener(UIEvent.GLOBAL_SETTINGS, globalSettings);	
			stage.addEventListener(UIEvent.GITHUB_HOME, showGitHubHome);
			stage.addEventListener(UIEvent.GITHUB_LOGIN, showGitHubLogin);
			stage.addEventListener(UIEvent.BEANSTALK_HOME, showBeanstalkHome);
			stage.addEventListener(UIEvent.BEANSTALK_LOGIN, showBeanstalkLogin);			
			stage.addEventListener(UIEvent.ADD_BKMK_TO_ACCOUNT, addBkmkToAccount);
			stage.addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseButton);
		}

		public function resize(w:Number, h:Number):void
		{
			_curtain.resize(w, h);
			if (_window) {
				_window.resize(w, h);
			// align with modal window //	
				_preloader.resize(w, h - 30);
			}	else{
			// align with summary view //	
				_preloader.resize(w, h, 204/2, -50);
			}
			if (_alert) _alert.resize(w, h);
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			if (_window == _welcome) hideModalWindow();
		}

		private function showWelcomeScreen(e:BookmarkEvent):void
		{
			showModalWindow(_welcome);
		}
	
		private function installGit(e:AppEvent):void 
		{
			_gitInstall.promptToInstall();
			showModalWindow(_gitInstall);
		}	
		
		private function upgradeGit(e:AppEvent):void
		{
			_gitUpgrade.promptToUpgrade();
			showModalWindow(_gitUpgrade);			
		}
		
		private function showGitHubLogin(e:UIEvent):void
		{
			showModalWindow(Hosts.github.login);
		}

		private function showBeanstalkLogin(e:UIEvent):void
		{
			showModalWindow(Hosts.beanstalk.login);			
		}
		
		private function showGitHubHome(e:UIEvent):void
		{
			Hosts.github.home.account = Hosts.github.loggedIn;
			showModalWindow(Hosts.github.home);
		}
		
		private function showBeanstalkHome(e:UIEvent):void
		{
			Hosts.beanstalk.home.account = Hosts.beanstalk.loggedIn;
			showModalWindow(Hosts.beanstalk.home);
		}			
		
		private function addBkmkToAccount(e:UIEvent):void
		{
			showModalWindow(_uploadWizard);
		}
		
		private function onDragAndDrop(e:UIEvent):void 
		{
			if (FileUtils.dirIsEmpty(e.data as File) == false){
				_dragAndDrop.file = e.data as File;
				showModalWindow(_dragAndDrop);
			} 	else{
				var m:String = 'Please add some files to this folder before attempting to track it.';
				onShowAlert(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));				
			}
		}

		private function onNewButtonClick(e:UIEvent):void 
		{
			showModalWindow(_new);
		}

		private function editBookmark(e:UIEvent):void
		{
			showModalWindow(_edit);
		}
		
		private function repairBookmark(e:BookmarkEvent):void
		{
			_repair.broken = e.data as Bookmark;
			showModalWindow(_repair);
			if(NativeApplication.supportsDockIcon){
 				DockIcon(NativeApplication.nativeApplication.icon).bounce(NotificationType.CRITICAL);
			}
		}
		
		private function addNewCommit(e:UIEvent):void 
		{
			showModalWindow(_commit);
		}
		
		private function showCommitOptions(e:UIEvent):void
		{
			_commitOptions.commit = e.data as Commit;
			showModalWindow(_commitOptions);	
		}		
		
		private function commitDetails(e:UIEvent):void
		{
			_details.commit = e.data as Commit;
			showModalWindow(_details);
		}		
		
		private function globalSettings(e:UIEvent):void
		{
			showModalWindow(_settings);
		}
		
		private function onAboutGit(e:UIEvent):void
		{
			showModalWindow(_gitAbout);
		}
		
		private function onAppExpired(e:AppEvent):void
		{
			showModalWindow(_appExpired);		
		}		
		
		private function promptToUpdate(e:AppEvent):void
		{
			_appUpdate.newVersion = e.data.n;
			showModalWindow(_appUpdate);
		}
		
		private function onPermissionsFailure(e:AppEvent):void
		{
			_permissions.request = e.data as String;
			showModalWindow(_permissions);
		}
		
		private function showLoader(e:AppEvent):void
		{
			setChildIndex(_preloader, numChildren-1);
			resize(stage.stageWidth, stage.stageHeight);
		}
		
	// adding & removing modal windows //	
		
		private function onCloseButton(e:UIEvent):void { hideModalWindow(); }
		private function onCurtainClick(e:MouseEvent):void { checkIsStickyWindow(); }		
		
		private function checkIsStickyWindow():void
		{
			if (_alert) return;
			for (var i:int = 0; i < _stickies.length; i++) if (_window == _stickies[i]) return;
			hideModalWindow();
		}
		
		private function showModalWindow(mw:ParentWindow):void
		{
			if (_window) removeChild(_window);
			addChild(mw);
			_window = mw;
			_window.filters = [];
			_curtain.show();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}
		
		private function hideModalWindow():void
		{
			removeChild(_window);
			_window = null;
			_curtain.hide();
		}

		private function onShowAlert(e:AppEvent):void
		{
			_alert = e.data as Alert;
			addChild(_alert);
			_curtain.show();
			if (_window) {
				_window.filters = [new BlurFilter(5, 5, 3)];			
			}
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}			
		
		private function onHideAlert(e:AppEvent):void
		{
			removeChild(_alert);
			if (_window) {
				stage.focus = _window;
				_window.filters = [];
			}	else{
				 _curtain.hide();
			}
			_alert = null;	
		}
		
	}
	
}
