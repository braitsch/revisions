package view.windows.editor {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.type.TextHeading;
	import view.ui.Form;
	import view.windows.base.ChildWindow;
	import view.windows.modals.system.Delete;
	import view.windows.modals.system.Message;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.engine.TextLine;

	public class BookmarkGeneral extends ChildWindow {

		private static var _text		:TextHeading;
		private static var _form		:Form = new Form(580);
		private static var _autoSave	:BookmarkAutoSave = new BookmarkAutoSave();
		private static var _glowFilter	:GlowFilter = new GlowFilter(0x000000, .1, 2, 2, 3, 3);
		private static var _height		:uint = 400;

		public function BookmarkGeneral()
		{
			setupHeading();
			setupForm();
			setupAutoSave();
			addOkButton('OK', 464, 350);
			addNoButton('Delete', 334, 350);
			addEventListener(UIEvent.ENTER_KEY, onUpdateBookmark);
			addEventListener(UIEvent.NO_BUTTON, onDeleteBookmark);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_SELECTED, onBookmarkSelected);
		}

		private function setupHeading():void
		{
			_text = new TextHeading('General Information About This Bookmark');
			addChild(_text);
		}

		private function setupForm():void
		{
			_form.y = 100;
			_form.fields = [{label:'Name'}, {label:'Location', enabled:false}];
			addChild(_form);			
		}

		private function setupAutoSave():void
		{
			_autoSave.buttonMode = true;
			_autoSave.minutes.restrict = '0-9';
			_autoSave.minutes.addEventListener(FocusEvent.FOCUS_OUT, onMinutesFocusOut);
			_autoSave.tf1.mouseEnabled = _autoSave.tf1.mouseChildren = false;
			_autoSave.tf2.mouseEnabled = _autoSave.tf2.mouseChildren = false;
			_autoSave.tf1.filters = [_glowFilter];
			_autoSave.tf2.filters = [_glowFilter];
			_autoSave.graphics.beginFill(0xff0000, 0);
			_autoSave.graphics.drawRect(0, 0, 225, 30);
			_autoSave.graphics.endFill();				
			_autoSave.addEventListener(MouseEvent.CLICK, onAutoSaveClick);
			_autoSave.x = 10;
			_autoSave.y = _height - 50;
			addChild(_autoSave);
		}
		
		private function onBookmarkSelected(e:AppEvent):void
		{
			_form.setField(1, AppModel.bookmark.path);
			_form.setField(0, AppModel.bookmark.label);
			_autoSave.check.visible = AppModel.bookmark.autosave != 0;
			_autoSave.minutes.text = AppModel.bookmark.autosave==0 ? String(60) : String(AppModel.bookmark.autosave);	
		}		
		
		private function onUpdateBookmark(e:UIEvent):void
		{
			if (checkMinutesInvalidValue()) {
				var m:String = Bookmark.validate(_form.getField(0), _form.getField(1), AppModel.bookmark);
				if (m != '') {
					AppModel.alert(new Message(m));
				}	else {
					saveNameInDatabase();
				}
			}
		}		

		private function onMinutesFocusOut(e:FocusEvent):void
		{
			checkMinutesInvalidValue();
		}
		
		private function checkMinutesInvalidValue():Boolean
		{
			var n:uint = uint(_autoSave.minutes.text);
			if (n >= 5 && n <= 90) {
				return true;
			}	else{
				AppModel.alert(new Message('Please enter a number between 5 & 90 minutes'));
				return false;
			}
		}

		private function onAutoSaveClick(e:MouseEvent):void
		{
			if ((e.target is TextLine) == false) _autoSave.check.visible = !_autoSave.check.visible;
		}
		
		private function onDeleteBookmark(e:UIEvent):void
		{
			AppModel.alert(new Delete(AppModel.bookmark));
		}
		
		private function saveNameInDatabase():void
		{
			AppModel.bookmark.autosave = _autoSave.check.visible ? uint(_autoSave.minutes.text) : 0;
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);
			AppModel.database.editRepository(AppModel.bookmark.label, _form.getField(0), _form.getField(1), AppModel.bookmark.autosave);				
		}
		
		private function onEditSuccessful(e:DataBaseEvent):void 
		{
			AppModel.bookmark.path = _form.getField(1);
			AppModel.bookmark.label = _form.getField(0);
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onEditSuccessful);		
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}			
						
	}
	
}
