package view.modals.bkmk {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindowBasic;
	import view.modals.system.Delete;
	import view.modals.system.Message;
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
			addEventListener(UIEvent.ENTER_KEY, onUpdateBookmark);
			
			_check.y = 220; 
			_check.label = 'Autosave Every 60 Minutes';
			_form.y = 90;
			_form.labels = ['Name', 'Location'];
			_form.enabled = [1];
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_form.setField(0, _bookmark.label);
			_form.setField(1, _bookmark.path);
			_check.selected = _bookmark.autosave != 0;			
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Delete(_bookmark)));
		}

		private function onUpdateBookmark(e:Event):void
		{
			var m:String = Bookmark.validate(_form.getField(0), _form.getField(1), _bookmark);
			if (m != '') {
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}	else {
				_bookmark.type == Bookmark.FILE ? updateGitDir() : updateDatabase();
			}			
		}
		
		private function updateGitDir():void
		{
			if (_form.getField(1) == _bookmark.path){
				updateDatabase();		
			}	else{
		// the file path has changed //		
				AppModel.proxies.creator.editAppStorageGitDirName(_bookmark.path, _form.getField(1));	
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
			AppModel.database.editRepository(_bookmark.label, _form.getField(0), _form.getField(1), _bookmark.autosave);				
		}
		
		private function onEditSuccessful(e:DataBaseEvent):void 
		{
			_bookmark.path = _form.getField(1);
			_bookmark.label = _form.getField(0);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);		
		}				
		
	}
	
}
