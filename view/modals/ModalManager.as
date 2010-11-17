package view.modals {
	import events.RepositoryEvent;
	import events.UIEvent;

	import events.InstallEvent;

	import model.AppModel;

	import utils.DragAndDropListener;

	import model.Bookmark;
	import view.history.HistoryView;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeDragEvent;

	public class ModalManager extends Sprite {

		private static var _dragAndDrop		:DragAndDropListener = new DragAndDropListener();	
		
	// modal windows //	
		private static var _add				:AddBookmark = new AddBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _remove			:RemoveBookmark = new RemoveBookmark();		private static var _commit			:CommitChanges = new CommitChanges();
		private static var _error			:UserError = new UserError();		
		
		private static var _history			:HistoryView = new HistoryView();		
		private static var _install			:InstallGit = new InstallGit();
		private static var _modified		:DetachedBranch = new DetachedBranch();

		public function ModalManager()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.USER_ERROR, onUserError);
			addEventListener(UIEvent.CLOSE_MODAL_WINDOW, onCloseModelWindow);	
			
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_ERROR, repairBookmark);
			AppModel.proxies.installer.addEventListener(InstallEvent.GIT_UNAVAILABLE, installGit);
			AppModel.proxies.branch.addEventListener(RepositoryEvent.BRANCH_DETACHED, onBranchDetached);
			AppModel.proxies.checkout.addEventListener(RepositoryEvent.COMMIT_MODIFIED, onCommitModified);
		}

		private function onUserError(e:UIEvent):void
		{
			_error.message = e.data as String;
			addChild(_error);
		}

		private function onAddedToStage(e:Event):void 
		{
			_dragAndDrop.target = stage;
			_dragAndDrop.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE, onDragAndDrop);						stage.addEventListener(UIEvent.ADD_BOOKMARK, addBookmark);			stage.addEventListener(UIEvent.EDIT_BOOKMARK, editBookmark);			stage.addEventListener(UIEvent.SAVE_PROJECT, addNewCommit);			stage.addEventListener(UIEvent.ADD_BRANCH, branchBookmark);
			stage.addEventListener(UIEvent.DELETE_BOOKMARK, removeBookmark);			stage.addEventListener(UIEvent.OPEN_HISTORY, viewHistory);		}	

		private function onDragAndDrop(e:NativeDragEvent):void 
		{
			addChild(_add);
			_add.local = _dragAndDrop.file.nativePath;
			NativeApplication.nativeApplication.activate();
		}		
		
	// commands //		

		private function installGit(e:InstallEvent):void 
		{
			_install.version = String(e.data);
			addChild(_install);
		}	

		private function addBookmark(e:UIEvent):void 
		{
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
	
		private function repairBookmark(e:RepositoryEvent):void
		{
			_repair.failed = e.data as Vector.<Bookmark>;
			addChild(_repair);
		}	
		
		private function onBranchDetached(e:RepositoryEvent):void 
		{
			trace("ModalManager.onBranchDetached(e) >> ", e.data.label);		}		
		
		private function onCommitModified(e:RepositoryEvent):void 
		{
			trace("ModalManager.onCommitModified(e)");
			addChild(_modified);	
		}							
		
		private function onCloseModelWindow(e:UIEvent):void 
		{
			removeChild(e.data as ModalWindow);
		}
			
	}
	
}
