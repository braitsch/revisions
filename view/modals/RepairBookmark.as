package view.modals {

	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.FileBrowser;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class RepairBookmark extends ModalWindow {

		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();
		private static var _failed		:Vector.<Bookmark>;
		private static var _bookmark	:Bookmark; // current bkmk being repaired //

		public function RepairBookmark()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.local_txt]));	
			super.addButtons([_view.browse_btn, _view.update_btn, _view.delete_btn]);
			
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.update_btn.addEventListener(MouseEvent.CLICK, onUpdateRepository);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteBookmark);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onDirectorySelection);				
		}
		
		public function set failed(v:Vector.<Bookmark>):void
		{
			_failed = v;
			repairBookmark(_failed[0]);
		}

		private function repairBookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = b.label;
			_view.local_txt.text = b.path;			
		}
		
		private function onBrowseButton(e:MouseEvent):void 
		{
			if (_bookmark.type == Bookmark.FILE){
				_browser.browseForFile('Select a file to be tracked by : '+_bookmark.label);
			}	else{
				_browser.browseForDirectory('Select a folder to be tracked by : '+_bookmark.label);
			}		
		}
		
		private function onDirectorySelection(e:UIEvent):void 
		{
			_view.local_txt.text = File(e.data).nativePath;	
		}
		
		private function onUpdateRepository(e:MouseEvent):void 
		{
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text);
			if (m == '') {
				AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditComplete);
				AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text);				
			}	else{
				dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
			}			
		}

		private function onEditComplete(e:DataBaseEvent):void
		{
			_failed.splice(0, 1);
			if (_failed.length){
				repairBookmark(_failed[0]);
			}	else{
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}

		private function onDeleteBookmark(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));	
		}
		
	}
	
}
