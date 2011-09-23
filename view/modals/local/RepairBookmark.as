package view.modals.local {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindow;
	import view.modals.system.Delete;
	import view.modals.system.Message;
	import com.adobe.crypto.MD5;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class RepairBookmark extends ModalWindow {

		private static var _view		:RepairBookmarkMC = new RepairBookmarkMC();
		private static var _broken		:Vector.<Bookmark>;

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
		
		public function set broken(v:Vector.<Bookmark>):void
		{
			_broken = v;
			showBrokenBookmark();
		}
		
		private function showBrokenBookmark():void
		{
			_view.name_txt.text = _broken[0].label;
			_view.path_txt.text = _broken[0].path;
		}

		private function onBrowseButton(e:MouseEvent):void 
		{
			if (_broken[0].type == Bookmark.FILE){
				super.browseForFile('Select a file to be tracked by : '+_broken[0].label);
			}	else{
				super.browseForDirectory('Select a folder to be tracked by : '+_broken[0].label);
			}		
		}
		
		private function onBrowserSelection(e:UIEvent):void 
		{
			_view.path_txt.text = File(e.data).nativePath;	
		}
		
		private function onUpdateBookmark(e:Event):void 
		{
			var m:String = Bookmark.validate(_view.name_txt.text, _view.path_txt.text, _broken[0]);
			if (m != '') {
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}	else {
				_broken[0].type == Bookmark.FILE ? updateGitDir() : updateDatabase();
			}		
		}
		
		private function updateGitDir():void
		{
			if (_view.path_txt.text == _broken[0].path){
				updateDatabase();		
			}	else{
		// the file path has changed //		
				var o:Object = {	oldFile	:_broken[0].path, 
									newFile	:_view.path_txt.text,
									oldMD5	:MD5.hash(_broken[0].path),
									newMD5	:MD5.hash(_view.path_txt.text)};
				AppModel.proxies.creator.editAppStorageGitDirName(o);
				AppModel.proxies.creator.addEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);
			}
		}
		
		private function onGitDirUpdated(e:AppEvent):void
		{
			updateDatabase();
			_broken[0].path = _view.path_txt.text;
			AppModel.proxies.creator.removeEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
		}
		
		private function updateDatabase():void
		{
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.editRepository(_broken[0].label, _view.name_txt.text, _view.path_txt.text, _broken[0].autosave);				
		}
		
		private function onDeleteBookmark(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Delete(_broken[0])));
			AppModel.database.addEventListener(DataBaseEvent.RECORD_DELETED, onEditSuccessful);
		}				
		
		private function onEditSuccessful(e:DataBaseEvent = null):void
		{
			_broken[0].path = _view.path_txt.text;
			_broken[0].label = _view.name_txt.text;
		// always check if there are more broken bkmks in the engine queue //
			_broken.splice(0, 1);
			if (_broken.length) {
				showBrokenBookmark();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.BOOKMARKS_REPAIRED));
			}
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_DELETED, onEditSuccessful);
		}

	}
	
}

