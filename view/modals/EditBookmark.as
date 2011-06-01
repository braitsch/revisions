package view.modals {

	import events.BookmarkEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.Bookmark;
	import flash.events.MouseEvent;

	public class EditBookmark extends ModalWindow {

		private static var _view		:EditBookmarkMC = new EditBookmarkMC();
		private static var _bookmark	:Bookmark;

		public function EditBookmark()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));	
			super.addButtons([_view.update_btn, _view.cancel_btn]);
			
		// ability to change file path disabled for now - just create a new bookmark //	
			_view.local_txt.selectable = false;
			_view.update_btn.addEventListener(MouseEvent.CLICK, onUpdateRepository);
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.target;
		}		

		private function onUpdateRepository(e:MouseEvent):void 
		{
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';		
			}	else{
				AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text);
				AppModel.database.addEventListener(BookmarkEvent.EDITED, onEditSuccessful);				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
			}
		}

		private function onEditSuccessful(e:DataBaseEvent):void 
		{
		// this dispatches an event from the bookmark that updates the views //	
			_bookmark.label = _view.name_txt.text;
			AppModel.database.removeEventListener(BookmarkEvent.EDITED, onEditSuccessful);
		}
		
	}
	
}
