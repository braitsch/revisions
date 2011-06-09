package view.modals {

	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.Bookmark;
	import utils.FileBrowser;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class EditBookmark extends ModalWindow {

		private static var _view		:EditBookmarkMC = new EditBookmarkMC();
		private static var _check1		:Sprite;
		private static var _bookmark	:Bookmark;
		private static var _browser		:FileBrowser = new FileBrowser();

		public function EditBookmark()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
			super.addCheckboxes([_view.check1]);			
			super.addButtons([_view.browse_btn, _view.delete_btn, _view.ok_btn]);
			
			_check1 = _view.check1.cross;
			_view.local_txt.selectable = false;
			_view.addEventListener(MouseEvent.CLICK, onButtonClick);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileSelection);	
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);					
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.target;
		}
		
		private function onFileSelection(e:UIEvent):void
		{
			_view.local_txt.text = e.data as String;			
		}		

		private function onButtonClick(e:MouseEvent):void 
		{
			switch(e.target.name){
				case 'check1' : _check1.visible = !_check1.visible;	break;
				case 'browse_btn' : 
					var m:String = _bookmark.file.isDirectory ? 'Directory' : 'File';
					_browser.browse('Please Select A '+m);
				break;
				case 'delete_btn' : 
					dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));	
				break;
				case 'ok_btn' : 
					if (validateName()){
						dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
						AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text);
					}	
				break;
			}
		}
		
		private function validateName():Boolean
		{
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';
				return false;
			}	else{
				return true;
			}
		}

		private function onEditSuccessful(e:DataBaseEvent):void 
		{
			_bookmark.label = _view.name_txt.text;
		}
		
	}
	
}
