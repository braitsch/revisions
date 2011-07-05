package view.modals {

	import events.BookmarkEvent;
	import events.DataBaseEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.FileBrowser;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class RepairBookmark extends ModalWindow {

		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();
		private static var _bookmark	:Bookmark; // current bkmk being repaired //

		public function RepairBookmark()
		{
			addChild(_view);
			super.addButtons([_view.browse_btn, _view.ok_btn, _view.delete_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onUpdateBookmark);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteBookmark);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onDirectorySelection);				
		}
		
		public function set bookmark(b:Bookmark):void
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
		
		private function onUpdateBookmark(e:MouseEvent):void 
		{
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text, _bookmark);
			if (m != '') {
				AppModel.engine.dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
			}	else {
				_bookmark.type == Bookmark.FILE ? updateGitDir() : updateDatabase();
			}		
		}
		
		private function updateGitDir():void
		{
			if (_view.local_txt.text == _bookmark.path){
				updateDatabase();		
			}	else{
		// the file path has changed //		
				AppModel.proxies.editor.editAppStorageGitDirName(_bookmark.path, _view.local_txt.text);
				AppModel.proxies.editor.addEventListener(InstallEvent.GIT_DIR_UPDATED, onGitDirUpdated);
			}
		}
		
		private function onGitDirUpdated(e:InstallEvent):void
		{
			updateDatabase();
			_bookmark.path = _view.local_txt.text;
			AppModel.proxies.editor.removeEventListener(InstallEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
		}
		
		private function updateDatabase():void
		{
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text, _bookmark.autosave);				
		}		
		
		private function onEditSuccessful(e:DataBaseEvent = null):void
		{
			_bookmark.path = _view.local_txt.text;
			_bookmark.label = _view.name_txt.text;
		// always check if there are more broken bkmks in the engine queue //	
			var bkmk:Bookmark = AppModel.engine.getNextBrokenBookmark();
			if (bkmk) {
				this.bookmark = bkmk;
			}	else{
				AppModel.proxies.status.resetTimer();
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
		}
		
		private function onDeleteBookmark(e:MouseEvent):void 
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));	
			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onDeleteComplete);
		}

		private function onDeleteComplete(e:BookmarkEvent):void 
		{
			onEditSuccessful();
		}
		
	}
	
}

