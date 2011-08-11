package view.modals.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;

	public class RepairBookmark extends ModalWindow {

		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();
		private static var _bookmark	:Bookmark; // current bkmk being repaired //

		public function RepairBookmark()
		{
			addChild(_view);
			super.drawBackground(550, 230);
			super.setTitle(_view, 'Repair Bookmark');
			super.setHeading(_view, 'The file this bookmark was pointing to appears to be missing. Please locate it.');
			super.defaultButton = _view.ok_btn;
			super.addButtons([_view.browse_btn, _view.delete_btn]);
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Location';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onUpdateBookmark);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteBookmark);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);	
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
				super.browseForFile('Select a file to be tracked by : '+_bookmark.label);
			}	else{
				super.browseForDirectory('Select a folder to be tracked by : '+_bookmark.label);
			}		
		}
		
		private function onBrowserSelection(e:UIEvent):void 
		{
			_view.local_txt.text = File(e.data).nativePath;	
		}
		
		override public function onEnterKey():void { onUpdateBookmark(); }
		private function onUpdateBookmark(e:MouseEvent = null):void 
		{
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text, _bookmark);
			if (m != '') {
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
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
				AppModel.proxies.editor.addEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);
			}
		}
		
		private function onGitDirUpdated(e:AppEvent):void
		{
			updateDatabase();
			_bookmark.path = _view.local_txt.text;
			AppModel.proxies.editor.removeEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
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

