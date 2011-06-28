package view.modals {

	import model.proxies.ConfigProxy;
	import events.BookmarkEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.db.AppSettings;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;

	public class ModalManager extends Sprite {

		private static var _welcome			:WelcomeScreen = new WelcomeScreen();
		private static var _new				:NewBookmark = new NewBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();		private static var _delete			:DeleteBookmark = new DeleteBookmark();
		private static var _commit			:NewCommit = new NewCommit();
		private static var _revert			:RevertToVersion = new RevertToVersion();		private static var _download		:DownloadVersion = new DownloadVersion();
		private static var _details			:CommitDetails = new CommitDetails();
		private static var _settings		:GlobalSettings = new GlobalSettings();
		private static var _updateApp		:UpdateApp = new UpdateApp();
		private static var _nameAndEmail	:NameAndEmail = new NameAndEmail();
		private static var _gitWindow		:GitWindow = new GitWindow();
		private static var _alert			:Alert = new Alert();
		private static var _expired			:AppExpired = new AppExpired();
		private static var _window			:ModalWindow;	// the active modal window //
		private static var _curtain			:ModalCurtain = new ModalCurtain();

		public function ModalManager()
		{
			addChild(_curtain);
			mouseEnabled = false;
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, showWelcomeScreen);
			AppModel.updater.addEventListener(InstallEvent.UPDATE_AVAILABLE, promptToUpdate);
			AppModel.proxies.config.addEventListener(InstallEvent.NAME_AND_EMAIL, addNameAndEmail);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_NOT_INSTALLED, installGit);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_NEEDS_UPDATING, upgradeGit);
		}

		public function init(stage:Stage):void
		{
			stage.addEventListener(UIEvent.DRAG_AND_DROP, onDragAndDrop);
			stage.addEventListener(UIEvent.ADD_BOOKMARK, onNewButtonClick);
			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);
			stage.addEventListener(UIEvent.DELETE_BOOKMARK, deleteBookmark);
			stage.addEventListener(UIEvent.COMMIT, addNewCommit);
			stage.addEventListener(UIEvent.REVERT, revertProject);
			stage.addEventListener(UIEvent.DOWNLOAD, downloadVersion);
			stage.addEventListener(UIEvent.COMMIT_DETAILS, commitDetails);
			stage.addEventListener(UIEvent.GLOBAL_SETTINGS, globalSettings);
			stage.addEventListener(UIEvent.SHOW_ALERT, onShowAlert);		
			stage.addEventListener(UIEvent.HIDE_ALERT, onCloseAlert);		
			stage.addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseButton);
			stage.addEventListener(InstallEvent.APP_EXPIRED, onAppExpired);
			stage.addEventListener(KeyboardEvent.KEY_UP, checkForEnterKey);
		}

		private function checkForEnterKey(e:KeyboardEvent):void
		{
			if (e.keyCode == 13 && _window != null) _window.onEnterKey();
		}

		public function resize(w:Number, h:Number):void
		{
			_curtain.resize(w, h);
			if (_window){
				_window.x = w/2 - _window.width / 2;
				_window.y = (h-50)/2 - _window.height / 2 + 50;
			}
			_alert.x = w/2 - _alert.width / 2;
			_alert.y = (h-50)/2 - _alert.height / 2 + 50;
		}
		
		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			if (_window == _welcome) hideModalWindow();
		}

		private function showWelcomeScreen(e:BookmarkEvent):void
		{
			showModalWindow(_welcome);
		}
	
		private function installGit(e:InstallEvent):void 
		{
			_gitWindow.promptToInstall();
			showModalWindow(_gitWindow);
		}	
		
		private function upgradeGit(e:InstallEvent):void
		{
			_gitWindow.promptToUpgrade();
			showModalWindow(_gitWindow);			
		}
		
		private function addNameAndEmail(e:InstallEvent):void
		{
			showModalWindow(_nameAndEmail);
		}		

		private function onDragAndDrop(e:UIEvent):void 
		{
			_new.addNewFromDropppedFile(e.data as File);
			showModalWindow(_new);
		}	

		private function onNewButtonClick(e:UIEvent):void 
		{
			_new.reset();
			showModalWindow(_new);
		}

		private function editBookmark(e:UIEvent):void
		{
			_edit.bookmark = e.data as Bookmark;
			showModalWindow(_edit);
		}
		
		private function deleteBookmark(e:UIEvent):void
		{
			_delete.bookmark = e.data as Bookmark;
			showModalWindow(_delete);
		}
		
		private function repairBookmark(e:BookmarkEvent):void
		{
			_repair.bookmark = e.data as Bookmark;
			showModalWindow(_repair);
		}			
		
		private function addNewCommit(e:UIEvent):void 
		{
			showModalWindow(_commit);
		}
		
		private function commitDetails(e:UIEvent):void
		{
			_details.commit = e.data as Commit;
			showModalWindow(_details);
		}		
		
		private function revertProject(e:UIEvent):void
		{
			_revert.commit = e.data as Commit;
			showModalWindow(_revert);			
		}
		
		private function downloadVersion(e:UIEvent):void
		{
			_download.commit = e.data as Commit;
			if (AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD)){	
				showModalWindow(_download);
			}	else{
				_download.selectDownloadLocation();
			}
		}
		
		private function globalSettings(e:UIEvent):void
		{
			showModalWindow(_settings);
		}
		
		private function onAppExpired(e:InstallEvent):void
		{
			showModalWindow(_expired);		
		}		
		
		private function promptToUpdate(e:InstallEvent):void
		{
			if (AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES)){
				_updateApp.newVersion = e.data.n;
				showModalWindow(_updateApp);
			}	else{
				checkAppIsInitialized();
				trace("ModalManager.promptToUpdate(e), Revisions "+e.data.n+' is Available');
			}
		}			

	// adding & removing modal windows //	
		
		private function onCloseButton(e:UIEvent):void { hideModalWindow(); }
		private function onCurtainClick(e:MouseEvent):void { hideModalWindow(); }		
		
		private function showModalWindow(mw:ModalWindow):void
		{
			if (_window) removeChild(_window);
			addChild(mw);
			_window = mw;
			_window.filters = [];
			_curtain.show();
		}
		
		private function hideModalWindow():void
		{
			if (checkGitIsInitialized() == false) return;
			if (_window == _updateApp) checkAppIsInitialized();
			if (_window) removeChild(_window);
			if (_alert.stage) removeChild(_alert);
			_window = null;
			_curtain.hide();
		}
		
		private function onShowAlert(e:UIEvent):void
		{
			_alert.message = e.data as String;
			_curtain.show();
			addChild(_alert);
			if (_window) _window.filters = [new BlurFilter(5, 5, 3)];
		}			
		
		private function onCloseAlert(e:UIEvent):void
		{
			removeChild(_alert);
			if (_window) _window.filters = [];
			if (_window == null) _curtain.hide();
		}
		
		private function checkGitIsInitialized():Boolean
		{
			var c:ConfigProxy = AppModel.proxies.config;
			if (c.gitInstalled == false) return false;
			if (c.userName == '') return false; 			
			if (c.userEmail == '') return false; 			
			return true;
		}
		
		private function checkAppIsInitialized():void
		{
			if (!AppMain.initialized) AppModel.updater.dispatchEvent(new InstallEvent(InstallEvent.APP_UP_TO_DATE));	
		}
			
	}
	
}
