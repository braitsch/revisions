package view.modals {
	import commands.UICommand;

	import events.DataBaseEvent;
	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Bookmark;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class EditBookmark extends ModalWindow {

		private static var _view		:EditBookmarkMC = new EditBookmarkMC();
		private static var _bookmark	:Bookmark;

		public function EditBookmark()
		{
			addChild(_view);
			super.cancel = _view.cancel_btn;			
			super.addInputs(Vector.<TextField>([_view.name_txt]));	
			super.addButtons([_view.update_btn, _view.cancel_btn]);
			
		// ability to change file path disabled for now - just create a new bookmark //	
			_view.local_txt.selectable = false;
			_view.update_btn.addEventListener(MouseEvent.CLICK, onUpdateRepository);
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.local;
		}		

		private function onUpdateRepository(e:MouseEvent):void 
		{
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';		
			}	else{
				AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text);
				AppModel.database.addEventListener(RepositoryEvent.BOOKMARK_EDITED, onEditSuccessful);				dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
			}
		}

		private function onEditSuccessful(e:DataBaseEvent):void 
		{
		// this dispatches an event from the bookmark that updates the views //	
			_bookmark.label = _view.name_txt.text;
			AppModel.database.removeEventListener(RepositoryEvent.BOOKMARK_EDITED, onEditSuccessful);
		}
		
	}
	
}
