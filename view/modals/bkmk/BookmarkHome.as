package view.modals.bkmk {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindowBasic;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BookmarkHome extends ModalWindowBasic {

		private static var _view		:BookmarkHomeMC = new BookmarkHomeMC();
		private static var _form		:Form = new Form(new Form2());
		private static var _check		:ModalCheckbox = new ModalCheckbox(true);
		private static var _bookmark	:Bookmark;

		public function BookmarkHome()
		{
			addChild(_view);
			addChild(_check);
			addChildAt(_form, 0);
			super.addButtons([_view.delete_btn]);
			super.defaultButton = _view.ok_btn;
			super.setHeading(_view, 'General information about this bookmark');
			
			_check.y = 220; 
			_check.label = 'Autosave Every 60 Minutes';
			_form.y = 90;
			_form.labels = ['Name', 'Location'];
			_form.inputs = [_view.name_txt];
			_form.deactivateFields(['field2']);
			_form.addEventListener(UIEvent.ENTER_KEY, onUpdateBookmark);
			_view.local_txt.selectable = false;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onUpdateBookmark);
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.path;
			_check.selected = _bookmark.autosave != 0;			
			_view.name_txt.setSelection(0, _view.name_txt.length);
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));		
		}

		override public function onEnterKey():void { onUpdateBookmark(); }
		private function onUpdateBookmark(e:Event = null):void
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
				AppModel.proxies.creator.editAppStorageGitDirName(_bookmark.path, _view.local_txt.text);	
				AppModel.proxies.creator.addEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);
			}
		}
		
		private function onGitDirUpdated(e:AppEvent):void
		{
			updateDatabase();
			AppModel.proxies.creator.removeEventListener(AppEvent.GIT_DIR_UPDATED, onGitDirUpdated);			
		}
		
		private function updateDatabase():void
		{
			_bookmark.autosave = _check.selected ? 60 : 0;
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
