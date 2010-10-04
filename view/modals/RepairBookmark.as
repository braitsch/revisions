package view.modals {
	import commands.UICommand;

	import model.AppModel;

	import utils.FileBrowser;

	import view.bookmarks.Bookmark;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class RepairBookmark extends ModelWindow {

		private static var _oldId		:String;
		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();

		public function RepairBookmark()
		{
			addChild(_view);
			super.addInputs(Vector.<TextField>([_view.name_txt, _view.local_txt]));	
			super.addButtons([_view.browse_btn, _view.update_btn, _view.delete_btn]);
			
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onDirectoryBrowse);
			_view.update_btn.addEventListener(MouseEvent.CLICK, onUpdateRepository);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteRepository);
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

		private function onDeleteRepository(e:MouseEvent):void 
		{
		// if it's broken, this just removes the broken bookmark & leaves file system alone.
			AppModel.database.deleteRepository(_view.name_txt.text);				
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));			
		}
		
	}
	
}
