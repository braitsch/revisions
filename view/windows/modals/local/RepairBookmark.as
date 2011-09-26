package view.windows.modals.local {

	import com.adobe.crypto.MD5;
	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Delete;
	import view.windows.modals.system.Message;

	public class RepairBookmark extends ParentWindow {

		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();
		private static var _broken		:Bookmark;

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
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteBookmark);
			addEventListener(UIEvent.ENTER_KEY, onUpdateBookmark);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}
		
		public function set broken(b:Bookmark):void
		{
			_broken = b;
			_view.name_txt.text = _broken.label;
			_view.path_txt.text = _broken.path;
		}
		
		private function onBrowseButton(e:MouseEvent):void 
		{
			if (_broken.type == Bookmark.FILE){
				super.browseForFile('Select a file to be tracked by : '+_broken.label);
			}	else{
				super.browseForDirectory('Select a folder to be tracked by : '+_broken.label);
			}		
		}
		
		private function onBrowserSelection(e:UIEvent):void 
		{
			_view.path_txt.text = File(e.data).nativePath;	
		}
		
		private function onUpdateBookmark(e:Event):void 
		{
			var m:String = Bookmark.validate(_view.name_txt.text, _view.path_txt.text, _broken);
			if (m != '') {
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}	else {
				_broken.type == Bookmark.FILE ? updateGitDir() : updateDatabase();
			}		
		}
		
		private function updateGitDir():void
		{
			if (_view.path_txt.text == _broken.path){
				updateDatabase();		
			}	else{
		// the file path has changed //		
				var o:Object = {	oldFile	:_broken.path, 
									newFile	:_view.path_txt.text,
									oldMD5	:MD5.hash(_broken.path),
									newMD5	:MD5.hash(_view.path_txt.text)};
				AppModel.proxies.creator.editAppStorageGitDirName(o);
				AppModel.proxies.creator.addEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);
			}
		}
		
		private function onGitDirUpdated(e:AppEvent):void
		{
			updateDatabase();
			_broken.path = _view.path_txt.text;
			AppModel.proxies.creator.removeEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
		}
		
		private function updateDatabase():void
		{
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.editRepository(_broken.label, _view.name_txt.text, _view.path_txt.text, _broken.autosave);				
		}
		
		private function onDeleteBookmark(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Delete(_broken)));
			AppModel.database.addEventListener(DataBaseEvent.RECORD_DELETED, onEditSuccessful);
		}				
		
		private function onEditSuccessful(e:DataBaseEvent = null):void
		{
			_broken.path = _view.path_txt.text;
			_broken.label = _view.name_txt.text;
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_DELETED, onEditSuccessful);
		}

	}
	
}

