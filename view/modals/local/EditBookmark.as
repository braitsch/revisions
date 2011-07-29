package view.modals.local {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;

	public class EditBookmark extends ModalWindow {

		private static var _view		:EditBookmarkMC = new EditBookmarkMC();
		private static var _bookmark	:Bookmark;
		private static var _check1		:ModalCheckbox = new ModalCheckbox(_view.check1, true);

		public function EditBookmark()
		{
			addChild(_view);
			super.addCloseButton();
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
			super.addButtons([_view.browse_btn, _view.delete_btn, _view.ok_btn, _view.github, _view.beanstalk]);
		
			_check1.label = 'Autosave Every 60 Minutes';
			_view.local_txt.selectable = false;
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onUpdateBookmark);
			_view.github.addEventListener(MouseEvent.CLICK, onGitHubClick);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalkClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
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
		
		private function onBrowserSelection(e:UIEvent):void
		{
			_view.local_txt.text = e.data as String;			
		}
		
		private function onBrowseButton(e:MouseEvent):void
		{
			if (_bookmark.type == Bookmark.FILE){
				super.browseForFile('Select a file to be tracked by : '+_bookmark.label);
			}	else{
				super.browseForDirectory('Select a folder to be tracked by : '+_bookmark.label);
			}
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));		
		}
		
		private function onGitHubClick(e:MouseEvent):void
		{
			if (AccountManager.github){
				dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_GH));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.REMOTE_LOGIN, {type:RemoteAccount.GITHUB, event:UIEvent.ADD_BKMK_TO_GH}));
			}	
		}
		
		private function onBeanstalkClick(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Beanstalk integration is coming in the next build.'));			
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
			AppModel.proxies.editor.removeEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
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
