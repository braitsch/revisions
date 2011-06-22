package view.modals {

	import events.InstallEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.FileBrowser;
	import view.ui.ModalCheckbox;
	import com.adobe.crypto.MD5;
	import flash.events.MouseEvent;

	public class EditBookmark extends ModalWindow {

		private static var _view		:EditBookmarkMC = new EditBookmarkMC();
		private static var _bookmark	:Bookmark;
		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _check1		:ModalCheckbox = new ModalCheckbox(_view.check1, true);

		public function EditBookmark()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
			super.addButtons([_view.browse_btn, _view.delete_btn, _view.ok_btn, _view.github, _view.beanstalk]);
		
			_check1.label = 'Autosave Every 60 Minutes';
			_view.local_txt.selectable = false;
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileSelection);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onUpdateBookmark);
			_view.github.addEventListener(MouseEvent.CLICK, onGitHubButton);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalkButton);
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.path;
			_check1.selected = _bookmark.autosave != 0;
		//TODO decide wether we're going to allow file path editing...
			_view.browse_btn.visible = false;
		}
		
		private function onFileSelection(e:UIEvent):void
		{
			_view.local_txt.text = e.data as String;			
		}
		
		private function onBrowseButton(e:MouseEvent):void
		{
			if (_bookmark.type == Bookmark.FILE){
				_browser.browseForFile('Select a file to be tracked by : '+_bookmark.label);
			}	else{
				_browser.browseForDirectory('Select a folder to be tracked by : '+_bookmark.label);
			}
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));				
		}
		
		private function onGitHubButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'GitHub & Beanstalk integration is coming in the next build.'));
		}
		
		private function onBeanstalkButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'GitHub & Beanstalk integration is coming in the next build.'));			
		}												

		private function onUpdateBookmark(e:MouseEvent):void
		{
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text, _bookmark);
			if (m != '') {
				dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
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
				AppModel.proxies.editor.addEventListener(InstallEvent.GIT_DIR_UPDATED, onGitDirUpdated);
				AppModel.proxies.editor.editAppStorageGitDirName(MD5.hash(_bookmark.path), MD5.hash(_view.local_txt.text));			
			}
		}
		
		private function onGitDirUpdated(e:InstallEvent):void
		{
			updateDatabase();
			AppModel.proxies.editor.removeEventListener(InstallEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
		}
		
		private function updateDatabase():void
		{
			_bookmark.autosave = _check1.selected ? 60 : 0;
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text, _bookmark.autosave);				
		}
		
		private function onEditSuccessful(e:DataBaseEvent):void 
		{
			_bookmark.path = _view.local_txt.text;
			_bookmark.label = _view.name_txt.text;
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);		
		}
		
	}
	
}
