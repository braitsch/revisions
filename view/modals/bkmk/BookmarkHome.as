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
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.engine.TextLine;

	public class BookmarkHome extends ModalWindowBasic {

		private static var _view		:BookmarkHomeMC = new BookmarkHomeMC();
		private static var _form		:Form = new Form(new Form2());
		private static var _bookmark	:Bookmark;
		private static var _glowFilter	:GlowFilter = new GlowFilter(0x000000, .1, 2, 2, 3, 3);		

		public function BookmarkHome()
		{
			addChild(_view);
			addChildAt(_form, 0);
			setupAutoSave();
			super.addButtons([_view.delete_btn]);
			super.defaultButton = _view.ok_btn;
			super.setHeading(_view, 'General information about this bookmark');
			addEventListener(UIEvent.ENTER_KEY, onUpdateBookmark);
			_form.y = 100;
			_form.labels = ['Name', 'Location'];
			_form.enabled = [1];
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDeleteButton);
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			_form.setField(0, _bookmark.label);
			_form.setField(1, _bookmark.path);
			_view.autoSave.check.visible = _bookmark.autosave != 0;
			_view.autoSave.minutes.text = _bookmark.autosave==0 ? 60 : _bookmark.autosave;
		}
		
		private function setupAutoSave():void
		{
			_view.autoSave.buttonMode = true;
			_view.autoSave.minutes.restrict = '0-9';
			_view.autoSave.minutes.addEventListener(FocusEvent.FOCUS_OUT, onMinutesFocusOut);
			_view.autoSave.tf1.mouseEnabled = _view.autoSave.tf1.mouseChildren = false;
			_view.autoSave.tf2.mouseEnabled = _view.autoSave.tf2.mouseChildren = false;
			_view.autoSave.tf1.filters = [_glowFilter];
			_view.autoSave.tf2.filters = [_glowFilter];
			_view.autoSave.graphics.beginFill(0xff0000, 0);
			_view.autoSave.graphics.drawRect(0, 0, 225, 30);
			_view.autoSave.graphics.endFill();				
			_view.autoSave.addEventListener(MouseEvent.CLICK, onAutoSaveClick);
		}

		private function onMinutesFocusOut(e:FocusEvent):void
		{
			checkMinutesInvalidValue();
		}
		
		private function checkMinutesInvalidValue():Boolean
		{
			var n:uint = uint(_view.autoSave.minutes.text);
			if (n >= 5 && n <= 90) {
				return true;
			}	else{
				var m:String = 'Please enter a number between 5 & 90 minutes';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
				return false;
			}
		}

		private function onAutoSaveClick(e:MouseEvent):void
		{
			if ((e.target is TextLine) == false) _view.autoSave.check.visible = !_view.autoSave.check.visible;
		}
		
		private function onDeleteButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Delete(_bookmark)));
		}

		private function onUpdateBookmark(e:Event):void
		{
			if (checkMinutesInvalidValue() == false) return;
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
			_bookmark.autosave = _view.autoSave.check.visible ? uint(_view.autoSave.minutes.text) : 0;
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
