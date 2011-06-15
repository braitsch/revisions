package view.modals {

	import events.BookmarkEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.Commit;
	import model.db.AppSettings;
	import system.LicenseManager;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ModalManager extends Sprite {

	// modal windows //	
		private static var _new				:NewBookmark = new NewBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _delete			:DeleteBookmark = new DeleteBookmark();		private static var _commit			:WindowCommit = new WindowCommit();
		private static var _revert			:WindowRevert = new WindowRevert();
		private static var _download		:WindowDownload = new WindowDownload();		private static var _details			:CommitDetails = new CommitDetails();
		private static var _settings		:GlobalSettings = new GlobalSettings();
		private static var _update			:WindowUpdate = new WindowUpdate();
		private static var _alert			:WindowAlert = new WindowAlert();
		private static var _expired			:WindowExpired = new WindowExpired();
		private static var _welcome			:WelcomeScreen = new WelcomeScreen();
		
		private static var _install			:InstallGit = new InstallGit();
		private static var _curtain			:ModalCurtain = new ModalCurtain();
		private static var _window			:ModalWindow;
 // active window onscreen //

		public function ModalManager()
		{
			addChild(_curtain);
			mouseEnabled = false;
			checkExpiredAndUpdates();
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			this.addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseButton);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, showWelcomeScreen);
			AppModel.updater.addEventListener(InstallEvent.UPDATE_AVAILABLE, promptToUpdate);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_UNAVAILABLE, installGit);
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
			stage.addEventListener(UIEvent.MULTIPLE_FILE_DROP, onMultipleFileDrop);		
		}

		public function resize(w:Number, h:Number):void
		{
			_curtain.resize(w, h);
			if (_window){
				_window.x = w/2 - _window.width / 2;
				_window.y = (h-50)/2 - _window.height / 2 + 50;
			}
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
			_install.version = String(e.data);
			showModalWindow(_install);
		}	

		private function onDragAndDrop(e:UIEvent):void 
		{
			_new.addNewFromDropppedFile(e.data as File);
			showModalWindow(_new);
		}	

		private function onNewButtonClick(e:UIEvent):void 
		{
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
		
		private function addNewCommit(e:UIEvent):void 
		{
		//TODO need to handle commit right clicks on bookmarks
		// right now these attempt to commit AppModel.bookmark
		// not the bookmark that was right clicked!!	
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
			if (AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD) == 'true'){	
				showModalWindow(_download);
			}	else{
				_download.selectDownloadLocation();
			}
		}
		
		private function globalSettings(e:UIEvent):void
		{
			showModalWindow(_settings);
		}
		
	// check expired & update application //
	
		private function checkExpiredAndUpdates():void
		{
			if (LicenseManager.checkExpired()){
				showModalWindow(_expired);
			}	else{
				AppModel.updater.checkForUpdate();				
			}
		}		
		
		private function promptToUpdate(e:InstallEvent):void
		{
			if (AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES) == 'true'){
				_update.newVersion = e.data.n;
				showModalWindow(_update);			
			}	else{
				trace("ModalManager.promptToUpdate(e), there is an update available");
			}
		}			

	// alerts //	
	
		private function repairBookmark(e:BookmarkEvent):void
		{
			_repair.failed = e.data as Vector.<Bookmark>;
			showModalWindow(_repair);
		}	
		
		private function onMultipleFileDrop(e:UIEvent):void
		{
			_alert.message = 'Please add only one file at a time.';
			showModalWindow(_alert);
		}
		
	// adding & removing modal windows //	
		
		private function onCloseButton(e:UIEvent):void { hideModalWindow(); }
		private function onCurtainClick(e:MouseEvent):void { hideModalWindow(); }		
		
		private function showModalWindow(mw:ModalWindow):void
		{
			if (_window) removeChild(_window);
			addChild(mw);
			_window = mw;
			_curtain.show();
		}
		
		private function hideModalWindow():void
		{
			removeChild(_window);
			_window = null;
			_curtain.hide();
		}		
			
	}
	
}
