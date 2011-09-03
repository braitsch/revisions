package view.modals.local {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindow;
	import view.ui.ModalCheckbox;

	public class DeleteBookmark extends ModalWindow {

		private static var _bookmark	:Bookmark;
		private static var _view		:DeleteBookmarkMC = new DeleteBookmarkMC();
		private static var _trashGit	:ModalCheckbox = new ModalCheckbox(false);
		private static var _trashFiles	:ModalCheckbox = new ModalCheckbox(false);

		public function DeleteBookmark()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 230);
			super.setTitle(_view, 'Delete Bookmark');
			super.addButtons([_view.delete_btn]);
			attachOptions();
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
		}				
		public function set bookmark($b:Bookmark):void
		{
			_bookmark = $b;
			_trashGit.selected = _trashFiles.selected = false;
			_view.textArea.message_txt.text = 'Are you sure you want to delete the bookmark "'+_bookmark.label+'"?';
		// disable options if the filepath to the bookmark is broken //	
			_trashGit.visible = _trashFiles.visible = _bookmark.exists;
		}
		
		private function attachOptions():void
		{
			addChild(_trashGit);			
			addChild(_trashFiles);
			_trashFiles.y = 165; _trashGit.y = 190;
			_trashFiles.label = 'Also Move Files to Trash';
			_trashGit.label = 'Destroy History (warning this cannot be undone)';					
		}
		
		private function onDeleteButton(e:MouseEvent):void 
		{
			AppModel.engine.deleteBookmark(_bookmark, _trashGit.selected, _trashFiles.selected);			
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
