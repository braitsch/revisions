package view.modals {

	import events.BookmarkEvent;
	import events.ErrorEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import view.history.HistoryView;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filesystem.File;

	public class ModalManager extends Sprite {

	// modal windows //	
		private static var _add				:AddBookmark = new AddBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _remove			:RemoveBookmark = new RemoveBookmark();		private static var _commit			:CommitChanges = new CommitChanges();
		private static var _untracked		:AddUntrackedFiles = new AddUntrackedFiles();		private static var _error			:UserError = new UserError();
		
		private static var _install			:InstallGit = new InstallGit();
		private static var _modified		:DetachedBranch = new DetachedBranch();
		private static var _curtain			:Shape = new Shape();
		private static var _welcome			:WelcomeScreen = new WelcomeScreen();
		
	//TODO all window instances need to be converted to sprites
		private static var _window			:Sprite; // active window onscreen //

		public function ModalManager()
		{
			addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseModelWindow);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, showWelcomeScreen);
				
			AppModel.engine.addEventListener(BookmarkEvent.UNTRACKED_FILES, promptToTrackFiles);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_UNAVAILABLE, installGit);
			AppModel.proxies.branch.addEventListener(BookmarkEvent.BRANCH_DETACHED, onBranchDetached);
			AppModel.proxies.checkout.addEventListener(BookmarkEvent.COMMIT_MODIFIED, onCommitModified);
		}

		public function init(stage:Stage):void
		{
			stage.addEventListener(UIEvent.DRAG_AND_DROP, onDragAndDrop);
//			stage.addEventListener(UIEvent.ADD_BOOKMARK, addBookmark);
//			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);
			stage.addEventListener(UIEvent.SAVE_PROJECT, addNewCommit);
//			stage.addEventListener(UIEvent.ADD_BRANCH, branchBookmark);
//			stage.addEventListener(UIEvent.DELETE_BOOKMARK, removeBookmark);
//			stage.addEventListener(UIEvent.OPEN_HISTORY, viewHistory);
//			stage.addEventListener(ErrorEvent.MULTIPLE_FILE_DROP, onUserError);			
		}
		
		public function resize(w:Number, h:Number):void
		{
			_curtain.graphics.clear();	
			_curtain.graphics.beginFill(0x000000, .5);
			_curtain.graphics.drawRect(0, 0, w, h);
			_curtain.graphics.endFill();
			if (_window){
				_window.x = w/2 - _window.width / 2;
				_window.y = (h-50)/2 - _window.height / 2 + 50;
			}
		}
		
		private function promptToTrackFiles(e:BookmarkEvent):void
		{
			showModalWindow(_untracked);
		}

		private function onUserError(e:ErrorEvent):void
		{
			addChild(_error);
			_error.message = e.type as String;
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			if (_welcome.stage) removeChild(_welcome);
			if (_curtain.stage) removeChild(_curtain);
		}

		private function showWelcomeScreen(e:BookmarkEvent):void
		{
			showModalWindow(_welcome);
		}
		
		private function installGit(e:InstallEvent):void 
		{
			_install.version = String(e.data);
			addChild(_install);
		}	

		private function onDragAndDrop(e:UIEvent):void 
		{
		// when a file or folder is dropped //	
			showModalWindow(_add);
			_add.addNewFromDropppedFile(e.data as File);
		}	

		private function addBookmark(e:UIEvent):void 
		{
		// when the button is clicked //	
			addChild(_add);
		}

		private function editBookmark(e:UIEvent):void
		{
			if (!AppModel.bookmark) return;
			_edit.bookmark = AppModel.bookmark;
			addChild(_edit);
		}
		
		private function branchBookmark(e:UIEvent):void 
		{
			// new branch wizard 
		}
		
		private function removeBookmark(e:UIEvent):void
		{
			_remove.bookmark = AppModel.bookmark;
			addChild(_remove);
		}
		
		private function addNewCommit(e:UIEvent):void 
		{
			addChild(_commit);
		}
		
	// alerts //	
	
		private function repairBookmark(e:BookmarkEvent):void
		{
			_repair.failed = e.data as Vector.<Bookmark>;
			addChild(_repair);
		}	
		
		private function onBranchDetached(e:BookmarkEvent):void 
		{
			trace("ModalManager.onBranchDetached(e) >> ", e.data.label);		}		
		
		private function onCommitModified(e:BookmarkEvent):void 
		{
			addChild(_modified);	
		}							
		
		private function onCloseModelWindow(e:UIEvent):void 
		{
			removeChild(e.data as ModalWindow);
		}
		
		private function showModalWindow(mw:ModalWindow):void
		{
			addChild(mw);
			_window = mw;
			_curtain.visible = true;
		}
		
		private function hideModalWindow(mw:ModalWindow):void
		{
			removeChild(mw);
			_window = null;
			_curtain.visible = false;			
		}		
			
	}
	
}
