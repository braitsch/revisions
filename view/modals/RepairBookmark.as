package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.Bookmark;
	import system.FileBrowser;

	public class RepairBookmark extends ModalWindow {

		private static var _oldId		:String;
		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();
		private static var _failed		:Vector.<Bookmark>;

		public function RepairBookmark()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.local_txt]));	
			super.addButtons([_view.browse_btn, _view.update_btn, _view.delete_btn]);
			
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onDirectoryBrowse);
			_view.update_btn.addEventListener(MouseEvent.CLICK, onUpdateRepository);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteRepository);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onDirectorySelection);				
		}
		
		public function set failed(v:Vector.<Bookmark>):void
		{
			_failed = v;
		//TODO iterate over failed vector to repair multiple bookmarks //	
			_oldId = _failed[0].label;			
			_view.name_txt.text = _failed[0].label;
			_view.local_txt.text = _failed[0].target;
		}
		
		private function onDirectoryBrowse(e:MouseEvent):void 
		{
			_browser.browse('Please Select A Directory');			
		}
		
		private function onDirectorySelection(e:UIEvent):void 
		{
			_view.local_txt.text = e.data as String;				
		}
		
		private function onUpdateRepository(e:MouseEvent):void 
		{
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';		
			}	else{
				AppModel.database.editRepository(_oldId, _view.name_txt.text, _view.local_txt.text);				
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}					

		private function onDeleteRepository(e:MouseEvent):void 
		{
		// if it's broken, this just removes the broken bookmark & leaves file system alone.
			AppModel.database.deleteRepository(_view.name_txt.text);				
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}
		
	}
	
}
