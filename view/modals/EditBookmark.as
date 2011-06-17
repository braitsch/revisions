package view.modals {

	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.FileBrowser;
	import view.ui.ModalCheckbox;

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
			_view.check1.addEventListener(MouseEvent.CLICK, onAutosaveCheck);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, onBrowseButton);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOKButton);
			_view.github.addEventListener(MouseEvent.CLICK, onGitHubButton);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalkButton);
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);					
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.path;
		}
		
		private function onFileSelection(e:UIEvent):void
		{
			_view.local_txt.text = e.data as String;			
		}
		
		private function onBrowseButton(e:MouseEvent):void
		{
			_browser.browse('Please Select A '+_bookmark.type == Bookmark.FOLDER ? 'Directory' : 'File');			
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));				
		}
		
		private function onAutosaveCheck(e:MouseEvent):void
		{
		//TODO write autosave value to the database //	
			trace("EditBookmark.onAutosaveCheck(e)", _check1.selected);
		}		
		
		private function onOKButton(e:MouseEvent):void
		{
			if (validateName()){
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				AppModel.database.editRepository(_bookmark.label, _view.name_txt.text, _view.local_txt.text);
			}			
		}
		
		private function onGitHubButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'GitHub & Beanstalk integration is coming in the next build.'));
		}
		
		private function onBeanstalkButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'GitHub & Beanstalk integration is coming in the next build.'));			
		}												

		private function validateName():Boolean
		{
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';
				return false;
			}	else{
				return true;
			}
		}

		private function onEditSuccessful(e:DataBaseEvent):void 
		{
			_bookmark.label = _view.name_txt.text;
		}
		
	}
	
}
