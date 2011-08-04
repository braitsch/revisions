package view.modals.bkmk {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.ModalWindowBasic;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class BookmarkHome extends ModalWindowBasic {

		private static var _view		:BookmarkHomeMC = new BookmarkHomeMC();
		private static var _check		:ModalCheckbox = new ModalCheckbox(_view.check, true);
		private static var _bookmark	:Bookmark;

		public function BookmarkHome()
		{
			addChild(_view);
			super.drawBackground(550, 210);
			super.addButtons([_view.delete_btn, _view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
		
			_check.label = 'Autosave Every 60 Minutes';
			_view.form.label1.text = 'Name';
			_view.form.label2.text = 'Location';
			_view.local_txt.selectable = false;
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onUpdateBookmark);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_view.name_txt.text = _bookmark.label;
			_view.local_txt.text = _bookmark.path;
			_check.selected = _bookmark.autosave != 0;			
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, _bookmark));		
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