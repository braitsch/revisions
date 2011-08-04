package view.modals {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import model.AppModel;
	import model.db.AppSettings;
	import model.remote.RemoteAccount;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import view.modals.bkmk.BookmarkEditor;
	import view.modals.git.GitAbout;
	import view.modals.git.GitInstall;
	import view.modals.git.GitUpgrade;
	import view.modals.git.NameAndEmail;
	import view.modals.local.AddDragAndDrop;
	import view.modals.local.AppExpired;
	import view.modals.local.AppUpdate;
	import view.modals.local.CommitDetails;
	import view.modals.local.DeleteBookmark;
	import view.modals.local.DownloadVersion;
	import view.modals.local.GlobalSettings;
	import view.modals.local.NewBookmark;
	import view.modals.local.NewCommit;
	import view.modals.local.RepairBookmark;
	import view.modals.local.RevertToVersion;
	import view.modals.local.WelcomeScreen;
	import view.modals.remote.AddBeanstalkRepo;
	import view.modals.remote.AddGitHubRepo;
	import view.modals.remote.AnonymousClone;
	import view.modals.remote.BeanStalkLogin;
	import view.modals.remote.GitHubHome;
	import view.modals.remote.GitHubLogin;
	import view.modals.remote.RemoteRepo;
	import view.modals.system.Alert;
	import view.modals.system.Confirm;
	import view.modals.system.Debug;
	import view.ui.Preloader;

	public class ModalManager extends Sprite {

		private static var _welcome			:WelcomeScreen = new WelcomeScreen();
		private static var _new				:NewBookmark = new NewBookmark();
		private static var _edit			:BookmarkEditor = new BookmarkEditor();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _delete			:DeleteBookmark = new DeleteBookmark();		private static var _dragAndDrop		:AddDragAndDrop = new AddDragAndDrop();
		private static var _commit			:NewCommit = new NewCommit();
		private static var _details			:CommitDetails = new CommitDetails();
		private static var _revert			:RevertToVersion = new RevertToVersion();		private static var _download		:DownloadVersion = new DownloadVersion();
		private static var _settings		:GlobalSettings = new GlobalSettings();
		private static var _appUpdate		:AppUpdate = new AppUpdate();
		private static var _appExpired		:AppExpired = new AppExpired();
		private static var _gitAbout		:GitAbout = new GitAbout();
		private static var _gitInstall		:GitInstall = new GitInstall();
		private static var _gitUpgrade		:GitUpgrade = new GitUpgrade();
		private static var _nameAndEmail	:NameAndEmail = new NameAndEmail();
		private static var _ghLogin			:GitHubLogin = new GitHubLogin();
		private static var _bsLogin			:BeanStalkLogin = new BeanStalkLogin();
		private static var _addToGitHub		:AddGitHubRepo = new AddGitHubRepo();
		private static var _addToBeanstalk	:AddBeanstalkRepo = new AddBeanstalkRepo();
		private static var _clone			:AnonymousClone = new AnonymousClone();		
		private static var _gitHub			:GitHubHome = new GitHubHome();
		private static var _alert			:Alert = new Alert();
		private static var _debug			:Debug = new Debug();
		private static var _confirm			:Confirm = new Confirm();
		private static var _preloader		:Preloader = new Preloader();		
		
	// windows that force user to make a decision - autoclose disabled //	
		private static var _stickies		:Vector.<ModalWindow> = new <ModalWindow>
				[ _repair, _appExpired, _appUpdate, _gitInstall, _gitUpgrade, _nameAndEmail, _ghLogin ];
				
		private static var _window			:ModalWindow;	// the active modal window //
		private static var _curtain			:ModalCurtain = new ModalCurtain();	

		public function ModalManager()
		{
			addChild(_curtain);
			addChild(_preloader);			
			mouseEnabled = false;
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			AppModel.engine.addEventListener(AppEvent.SHOW_DEBUG, onShowDebug);
			AppModel.engine.addEventListener(AppEvent.HIDE_DEBUG, onHideDebug);
			AppModel.engine.addEventListener(AppEvent.SHOW_ALERT, onShowAlert);
			AppModel.engine.addEventListener(AppEvent.HIDE_ALERT, onHideAlert);	
			AppModel.engine.addEventListener(AppEvent.SHOW_CONFIRM, onShowConfirm);
			AppModel.engine.addEventListener(AppEvent.HIDE_CONFIRM, onHideConfirm);				
			AppModel.engine.addEventListener(AppEvent.SHOW_LOADER, showLoader);
			AppModel.engine.addEventListener(AppEvent.HIDE_LOADER, hideLoader);					
			AppModel.engine.addEventListener(AppEvent.LOADER_TEXT, setLoaderText);					
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, showWelcomeScreen);
			AppModel.engine.addEventListener(AppEvent.APP_EXPIRED, onAppExpired);
			AppModel.updater.addEventListener(AppEvent.APP_UPDATE_AVAILABLE, promptToUpdate);
			AppModel.proxies.config.addEventListener(AppEvent.GIT_NAME_AND_EMAIL, addNameAndEmail);
			AppModel.proxies.config.addEventListener(AppEvent.GIT_NOT_INSTALLED, installGit);
			AppModel.proxies.config.addEventListener(AppEvent.GIT_NEEDS_UPDATING, upgradeGit);
		}

		public function init(stage:Stage):void
		{
			stage.stageFocusRect = false;
			stage.addEventListener(UIEvent.DRAG_AND_DROP, onDragAndDrop);
			stage.addEventListener(UIEvent.ADD_BOOKMARK, onNewButtonClick);
			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);
			stage.addEventListener(UIEvent.DELETE_BOOKMARK, deleteBookmark);
			stage.addEventListener(UIEvent.DELETE_BRANCH, deleteBranch);
			stage.addEventListener(UIEvent.COMMIT, addNewCommit);
			stage.addEventListener(UIEvent.REVERT, revertProject);
			stage.addEventListener(UIEvent.DOWNLOAD, downloadVersion);
			stage.addEventListener(UIEvent.SHOW_COMMIT, commitDetails);
			stage.addEventListener(UIEvent.ABOUT_GIT, onAboutGit);
			stage.addEventListener(UIEvent.GLOBAL_SETTINGS, globalSettings);	
			stage.addEventListener(UIEvent.GITHUB_HOME, showGitHubHome);
			stage.addEventListener(UIEvent.REMOTE_LOGIN, showRemoteLogin);
			stage.addEventListener(UIEvent.ANONYMOUS_CLONE, showAnonymousClone);			
			stage.addEventListener(UIEvent.ADD_REMOTE_TO_BOOKMARK, addBkmkToRemote);
			stage.addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseButton);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpEvent);			
		}

		private function onKeyUpEvent(e:KeyboardEvent):void
		{
			if (e.keyCode == 13){
				if (_alert.stage) {
					_alert.onEnterKey();
				}	else if (_debug.stage){
					_debug.onEnterKey();
				}	else if (_window != null){
					_window.onEnterKey();
				}
			}
		}

		public function resize(w:Number, h:Number):void
		{
			_curtain.resize(w, h);
			if (_window) {
				_window.resize(w, h);
			// align with modal window //	
				_preloader.resize(w, h);
			}	else{
			// align with summary view //	
				_preloader.resize(w, h, 204/2, -20);
			}
			if (_alert.stage) _alert.resize(w, h);
			if (_debug.stage) _debug.resize(w, h);
			if (_confirm.stage) _confirm.resize(w, h);			
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
		
		private function showRemoteLogin(e:UIEvent):void
		{
			if (e.data.type == RemoteAccount.GITHUB){
				showModalWindow(_ghLogin);
				_ghLogin.onSuccessEvent = e.data.event;
			}	else if (e.data.type == RemoteAccount.BEANSTALK){
				showModalWindow(_bsLogin);
				_bsLogin.onSuccessEvent = e.data.event;
			}
		}		
		
		private function addNameAndEmail(e:AppEvent):void
		{
			showModalWindow(_nameAndEmail);
		}		

		private function onDragAndDrop(e:UIEvent):void 
		{
			_dragAndDrop.file = e.data as File;
			showModalWindow(_dragAndDrop);
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
		
		private function addBkmkToRemote(e:UIEvent):void
		{
			var w:RemoteRepo;
			switch(e.data){
				case RemoteAccount.GITHUB :	w = _addToGitHub; break;
				case RemoteAccount.BEANSTALK : w = _addToBeanstalk; break;
			}
			w.bookmark = AppModel.bookmark;
			showModalWindow(w);
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
		
		private function deleteBranch(e:UIEvent):void
		{
			_alert.message = 'you are trying to delete branch '+e.data.name;
			showSpecial(_alert);			
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
		
		private function onAboutGit(e:UIEvent):void
		{
			showModalWindow(_gitAbout);
		}
		
		private function showGitHubHome(e:UIEvent):void
		{
			showModalWindow(_gitHub);
		}
		
		private function showAnonymousClone(e:UIEvent):void
		{
			showModalWindow(_clone);	
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
		
		private function showLoader(e:AppEvent):void
		{
			_preloader.show();
			_preloader.label = e.data as String;
			setChildIndex(_preloader, numChildren-1);
			resize(stage.stageWidth, stage.stageHeight);
		}
		
		private function hideLoader(e:AppEvent):void 
		{
			_preloader.hide();
		}
		
		private function setLoaderText(e:AppEvent):void
		{
			_preloader.label = e.data as String;			
		}								

	// adding & removing modal windows //	
		
		private function onCloseButton(e:UIEvent):void { hideModalWindow(); }
		private function onCurtainClick(e:MouseEvent):void { checkIsStickyWindow(); }		
		
		private function checkIsStickyWindow():void
		{
			if (_debug.stage || _alert.stage) return;
			for (var i:int = 0; i < _stickies.length; i++) if (_window == _stickies[i]) return;
			hideModalWindow();
		}
		
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
			removeChild(_window);
			_window = null;
			_curtain.hide();
		}

	// special windows alert, debug & confirm //

		private function onShowAlert(e:AppEvent):void
		{
			_alert.message = e.data as String;
			showSpecial(_alert);
		}			
		
		private function onHideAlert(e:AppEvent):void
		{
			hideSpecial(_alert);
		}
		
		private function onShowDebug(e:AppEvent):void
		{
			_debug.message = e.data as Object;
			showSpecial(_debug);
		}			
		
		private function onHideDebug(e:AppEvent):void
		{
			hideSpecial(_debug);
		}
		
		private static var _confirmTarget:*;
		private function onShowConfirm(e:AppEvent):void 
		{
			_confirmTarget = e.data.target;
			_confirm.message = e.data.message;
			showSpecial(_confirm);
		}
		
		private function onHideConfirm(e:AppEvent):void
		{
			_confirmTarget.onConfirm(e.data as Boolean);
			hideSpecial(_confirm);
		}			
		
		private function showSpecial(w:ModalWindow):void
		{
			addChild(w);
			_curtain.show();
			stage.focus = w;
			if (_window) {
				_window.locked = true;
				_window.filters = [new BlurFilter(5, 5, 3)];			
			}
		}
		
		private function hideSpecial(w:ModalWindow):void
		{
			removeChild(w);
			if (_window) {
				stage.focus = _window;
				_window.filters = [];
				_window.locked = false;
			}	else{
				 _curtain.hide();
			}
		}
		
	}
	
}
