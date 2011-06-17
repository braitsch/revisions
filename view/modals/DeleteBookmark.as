package view.modals {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.ModalCheckbox;

	public class DeleteBookmark extends ModalWindow {

		private static var _bookmark	:Bookmark;
		private static var _view		:DeleteBookmarkMC = new DeleteBookmarkMC();
		private static var _trashGit	:ModalCheckbox = new ModalCheckbox(_view.check2, false);
		private static var _trashFiles	:ModalCheckbox = new ModalCheckbox(_view.check1, false);

		public function DeleteBookmark()
		{
			addChild(_view);
			super.addButtons([_view.delete_btn]);
			_trashFiles.label = 'Also Move Files to Trash';
			_trashGit.label = 'Destroy History (warning this cannot be undone)';
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
		}				
		public function set bookmark($b:Bookmark):void
		{
			_bookmark = $b;
			_trashGit.selected = _trashFiles.selected = false;
			_view.message_txt.text = 'Are you sure you want to deal the bookmark "'+_bookmark.label+'"?';
		}
		
		private function onDeleteButton(e:MouseEvent):void 
		{
			AppModel.engine.deleteBookmark(_bookmark, _trashGit.selected, _trashFiles.selected);			
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
