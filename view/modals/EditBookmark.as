package view.modals {
	import commands.UICommand;

	import model.AppModel;

	import utils.FileBrowser;

	import view.bookmarks.Bookmark;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class EditBookmark extends ModelWindow {

		private static var _oldId		:String;
		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _view		:EditBookmarkMC = new EditBookmarkMC();

		public function EditBookmark()
		{
			addChild(_view);
			super.cancel = _view.cancel_btn;			
			super.addInputs(Vector.<TextField>([_view.name_txt, _view.local_txt]));	
			super.addButtons([_view.browse_btn, _view.update_btn, _view.cancel_btn]);
			
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onDirectoryBrowse);
			_view.update_btn.addEventListener(MouseEvent.CLICK, onUpdateRepository);
			_browser.addEventListener(UICommand.FILE_BROWSER_SELECTION, onDirectorySelection);	
		}

		public function set bookmark($b:Bookmark):void
		{
			_oldId = $b.label;
			_view.name_txt.text = $b.label;
			_view.local_txt.text = $b.local;
		}		

		private function onDirectoryBrowse(e:MouseEvent):void 
		{
			_browser.browse('Please Select A Directory');			
		}
		
		private function onDirectorySelection(e:UICommand):void 
		{
			if (!super.isValidTarget(e.data as String, _view.local_txt)) return;				
			_view.local_txt.text = e.data as String;				
		}
		
		private function onUpdateRepository(e:MouseEvent):void 
		{
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';		
			}	else{
				AppModel.database.editRepository(_oldId, _view.name_txt.text, _view.local_txt.text);
				dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
			}
		}
		
	}
	
}
