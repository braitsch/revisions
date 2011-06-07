package view.modals {

	import events.BookmarkEvent;
	import events.ErrorEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.Commit;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ModalManager extends Sprite {

	// modal windows //	
		private static var _new				:NewBookmark = new NewBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _remove			:RemoveBookmark = new RemoveBookmark();		private static var _commit			:SaveCommit = new SaveCommit();
		private static var _details			:CommitDetails = new CommitDetails();
		private static var _untracked		:AddUntrackedFiles = new AddUntrackedFiles();		private static var _error			:UserError = new UserError();
		
		private static var _install			:InstallGit = new InstallGit();
		private static var _modified		:DetachedBranch = new DetachedBranch();
		private static var _curtain			:ModalCurtain = new ModalCurtain();
		private static var _welcome			:WelcomeScreen = new WelcomeScreen();
		private static var _window			:ModalWindow; // active window onscreen //

		public function ModalManager()
		{
			addChild(_curtain);
			mouseEnabled = false;
			addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseButton);
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, showWelcomeScreen);
			AppModel.engine.addEventListener(BookmarkEvent.UNTRACKED_FILES, promptToTrackFiles);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_UNAVAILABLE, installGit);
			AppModel.proxies.checkout.addEventListener(BookmarkEvent.COMMIT_MODIFIED, onCommitModified);
		}

		public function init(stage:Stage):void
		{
			stage.addEventListener(UIEvent.DRAG_AND_DROP, onDragAndDrop);
			stage.addEventListener(UIEvent.ADD_BOOKMARK, onNewButtonClick);
			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);
			stage.addEventListener(UIEvent.SAVE_PROJECT, addNewCommit);
			stage.addEventListener(UIEvent.DELETE_BOOKMARK, removeBookmark);
			stage.addEventListener(UIEvent.COMMIT_DETAILS, showCommitDetails);
			stage.addEventListener(ErrorEvent.MULTIPLE_FILE_DROP, onUserError);			
		}

		public function resize(w:Number, h:Number):void
		{
			_curtain.resize(w, h);
			if (_window){
				_window.x = w/2 - _window.width / 2;
				_window.y = (h-50)/2 - _window.height / 2 + 50;
			}
		}
		
		private function promptToTrackFiles(e:BookmarkEvent):void
		{
			showModalWindow(_untracked);
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			if (_welcome.stage) hideModalWindow(_welcome);
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
			_edit.bookmark = AppModel.bookmark;
			showModalWindow(_edit);
		}
		
		private function removeBookmark(e:UIEvent):void
		{
			_remove.bookmark = AppModel.bookmark;
			showModalWindow(_remove);
		}
		
		private function addNewCommit(e:UIEvent):void 
		{
			showModalWindow(_commit);
		}
		
		private function showCommitDetails(e:UIEvent):void
		{
			_details.commit = e.data as Commit;
			showModalWindow(_details);
		}		
		
	// alerts //	
	
		private function repairBookmark(e:BookmarkEvent):void
		{
			_repair.failed = e.data as Vector.<Bookmark>;
			showModalWindow(_repair);
		}	
		
		private function onCommitModified(e:BookmarkEvent):void 
		{
			showModalWindow(_modified);	
		}
		
		private function onUserError(e:ErrorEvent):void
		{
			_error.message = e.type as String;
			showModalWindow(_error);
		}									
		
	// adding & removing modal windows //	
		
		private function onCloseButton(e:UIEvent):void {hideModalWindow(_window);}
		private function onCurtainClick(e:MouseEvent):void {hideModalWindow(_window);}		
		
		private function showModalWindow(mw:ModalWindow):void
		{
			addChild(mw);
			_window = mw;
			_curtain.show();
		}
		
		private function hideModalWindow(mw:ModalWindow):void
		{
			removeChild(mw);
			_window = null;
			_curtain.hide();
		}		
			
	}
	
}
