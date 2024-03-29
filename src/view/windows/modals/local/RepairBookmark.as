package view.windows.modals.local {

	import events.AppEvent;
	import events.DataBaseEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Bookmark;
	import view.btns.FormButton;
	import view.type.TextHeading;
	import view.ui.Form;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Delete;
	import view.windows.modals.system.Message;
	import com.adobe.crypto.MD5;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class RepairBookmark extends ParentWindow {

		private static var _form		:Form = new Form(530);
		private static var _heading		:TextHeading;
		private static var _broken		:Bookmark;
		private static var _newFile		:File;

		public function RepairBookmark()
		{
			super.drawBackground(550, 250);
			super.title = 'Repair Bookmark';
			_heading = new TextHeading('The file this bookmark was pointing to appears to be missing. Please locate it.');
			addChild(_heading);
			addRepairForm();
			addNoButton('Delete', 285, 200);
			addOkButton('OK', 415, 200);
			addEventListener(UIEvent.ENTER_KEY, onUpdateBookmark);
			addEventListener(UIEvent.NO_BUTTON, onDeleteBookmark);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}

		private function addRepairForm():void
		{
			_form.y = 100;
			_form.fields = [{label:'Name'}, {label:'Location', enabled:false}];
			addChild(_form);
			var b:FormButton = new FormButton('Browse');
				b.x = 415; b.y = _form.y + 37;
				b.addEventListener(MouseEvent.CLICK, onBrowseButton);
			addChild(b);
		}
		
		public function set broken(b:Bookmark):void
		{
			_broken = b;
			_form.setField(0, _broken.label);
			_form.setField(1, _broken.path);
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
			_newFile = e.data as File;
			_form.setField(1, _newFile.nativePath);
		}
		
		private function onUpdateBookmark(e:Event):void 
		{
			var m:String = Bookmark.validate(_form.getField(0), _form.getField(1), _broken);
			trace("RepairBookmark.onUpdateBookmark(e)", m);
			if (m != '') {
				AppModel.alert(new Message(m));
			}	else {
				_broken.type == Bookmark.FILE ? setFileLocation() : updateDatabase();
			}		
		}
		
		private function onDeleteBookmark(e:UIEvent):void 
		{
			AppModel.alert(new Delete(_broken));
			AppModel.database.addEventListener(DataBaseEvent.RECORD_DELETED, onBookmarkDeleted);
		}		
		
		private function setFileLocation():void
		{
			if (_form.getField(1) == _broken.path){
				updateDatabase();		
			}	else{
		// the file path has changed //		
				var o:Object = {	oldFile	:MD5.hash(_broken.path), 
									newFile	:MD5.hash(_newFile.nativePath),
									newTree :_newFile.parent.nativePath};
				AppProxies.creator.setFileLocation(o);
				AppModel.engine.addEventListener(AppEvent.WORKTREE_UPDATED, onFileLocalUpdated);
			}
		}
		
		private function onFileLocalUpdated(e:AppEvent):void
		{
			updateDatabase();
			AppModel.engine.removeEventListener(AppEvent.WORKTREE_UPDATED, onFileLocalUpdated);			
		}
		
		private function updateDatabase():void
		{
			AppModel.database.addEventListener(DataBaseEvent.RECORD_EDITED, onBookmarkRepaired);
			AppModel.database.editRepository(_broken.label, _form.getField(0), _form.getField(1), _broken.autosave);
		}

		private function onBookmarkRepaired(e:DataBaseEvent):void
		{
			_broken.path = _form.getField(1);
			_broken.label = _form.getField(0);
			AppModel.dispatch(AppEvent.BOOKMARK_REPAIRED);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_EDITED, onBookmarkRepaired);			
		}

		private function onBookmarkDeleted(e:DataBaseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.database.removeEventListener(DataBaseEvent.RECORD_DELETED, onBookmarkDeleted);
		}

	}
	
}

