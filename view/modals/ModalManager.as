package view.modals {

	import events.ErrorEvent;
	import events.InstallEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import utils.DragAndDropListener;
	import view.history.HistoryView;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;

	public class ModalManager extends Sprite {

		private static var _dragAndDrop		:DragAndDropListener = new DragAndDropListener();	
		
	// modal windows //	
		private static var _add				:AddBookmark = new AddBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _remove			:RemoveBookmark = new RemoveBookmark();		private static var _commit			:CommitChanges = new CommitChanges();
		private static var _autoInit		:AutoInit = new AutoInit();		private static var _error			:UserError = new UserError();
		
		private static var _history			:HistoryView = new HistoryView();		
		private static var _install			:InstallGit = new InstallGit();
		private static var _modified		:DetachedBranch = new DetachedBranch();

		public function ModalManager()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseModelWindow);	
			
			AppModel.engine.addEventListener(BookmarkEvent.STATUS, checkForAutoInit);
			AppModel.engine.addEventListener(BookmarkEvent.PATH_ERROR, repairBookmark);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_UNAVAILABLE, installGit);
			AppModel.proxies.branch.addEventListener(BookmarkEvent.BRANCH_DETACHED, onBranchDetached);
			AppModel.proxies.checkout.addEventListener(BookmarkEvent.COMMIT_MODIFIED, onCommitModified);
		}

		private function checkForAutoInit(e:BookmarkEvent):void
		{
			var k:Boolean = AppModel.bookmark.promptToAutoInit();
			if (k) addChild(_autoInit);
		}

		private function onUserError(e:ErrorEvent):void
		{
			addChild(_error);
			_error.message = e.type as String;
		}

		private function onAddedToStage(e:Event):void 
		{
			_dragAndDrop.target = stage;
			stage.addEventListener(UIEvent.DRAG_AND_DROP, onDragAndDrop);			stage.addEventListener(UIEvent.ADD_BOOKMARK, addBookmark);			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);			stage.addEventListener(UIEvent.SAVE_PROJECT, addNewCommit);			stage.addEventListener(UIEvent.ADD_BRANCH, branchBookmark);			stage.addEventListener(UIEvent.DELETE_BOOKMARK, removeBookmark);
			stage.addEventListener(UIEvent.OPEN_HISTORY, viewHistory);			stage.addEventListener(ErrorEvent.MULTIPLE_FILE_DROP, onUserError);					}		
		
	// commands //		

		private function installGit(e:InstallEvent):void 
		{
			_install.version = String(e.data);
			addChild(_install);
		}	

		private function onDragAndDrop(e:UIEvent):void 
		{
		// when a file or folder is dropped //	
			addChild(_add);
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
		
		private function viewHistory(e:UIEvent):void 
		{
			addChild(_history);
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
			
	}
	
}
