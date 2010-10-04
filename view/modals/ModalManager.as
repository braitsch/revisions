package view.modals {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;

	import utils.DragAndDropListener;

	import view.bookmarks.Bookmark;
	import view.history.HistoryView;

	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeDragEvent;

	public class ModalManager extends Sprite {

		private static var _bookmark		:Bookmark;
		private static var _dragAndDrop		:DragAndDropListener = new DragAndDropListener();	
		
	// modal windows //	
		private static var _add				:AddBookmark = new AddBookmark();
		private static var _edit			:EditBookmark = new EditBookmark();
		private static var _repair			:RepairBookmark = new RepairBookmark();
		private static var _remove			:RemoveBookmark = new RemoveBookmark();		private static var _commit			:Commit = new Commit();
		private static var _history			:HistoryView = new HistoryView();		
		private static var _install			:InstallGit = new InstallGit();	

		public function ModalManager()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			addEventListener(UICommand.CLOSE_MODAL_WINDOW, onCloseModelWindow);	
			AppModel.getInstance().addEventListener(RepositoryEvent.SET_BOOKMARK, onBookmarkChange);										
		}

		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			_bookmark = e.data as Bookmark;
		}

		private function onAddedToStage(e:Event):void 
		{
			_dragAndDrop.target = stage;
			_dragAndDrop.addEventListener(NativeDragEvent.NATIVE_DRAG_COMPLETE, onDragAndDrop);
			stage.addEventListener(UICommand.INSTALL_GIT, installGit);			stage.addEventListener(UICommand.NEW_BOOKMARK, addBookmark);			stage.addEventListener(UICommand.EDIT_BOOKMARK, editBookmark);			stage.addEventListener(UICommand.SAVE_PROJECT, addNewCommit);			stage.addEventListener(UICommand.REPAIR_BOOKMARK, repairBookmark);			stage.addEventListener(UICommand.ADD_BRANCH, branchBookmark);			stage.addEventListener(UICommand.DELETE_BOOKMARK, removeBookmark);
			stage.addEventListener(UICommand.VIEW_HISTORY, viewHistory);			}	

		private function onDragAndDrop(e:NativeDragEvent):void 
		{
			addChild(_add);
			_add.local = _dragAndDrop.file.nativePath;
			NativeApplication.nativeApplication.activate();
		}		
		
	// modal windows //		

		private function installGit(e:UICommand):void 
		{
			_install.version = String(e.data);
			addChild(_install);
		}	

		private function addBookmark(e:UICommand):void 
		{
			addChild(_add);
		}

		private function editBookmark(e:UICommand):void
		{
			if (!_bookmark) return;
			_edit.bookmark = _bookmark;
			addChild(_edit);
		}
		
		private function repairBookmark(e:UICommand):void
		{
			_repair.bookmark = e.data as Bookmark;
			addChild(_repair);
		}
		
		private function branchBookmark(e:UICommand):void 
		{
			// new branch wizard 
		}
		
		private function removeBookmark(e:UICommand):void
		{
			_remove.bookmark = _bookmark;
			addChild(_remove);
		}
		
		private function addNewCommit(e:UICommand):void 
		{
			addChild(_commit);
		}
		
		private function viewHistory(e:UICommand):void 
		{
			addChild(_history);
		}				
		
		private function onCloseModelWindow(e:UICommand):void 
		{
			removeChild(e.data as ModelWindow);
		}
			
	}
	
}
