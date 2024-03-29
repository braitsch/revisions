package view.windows.modals.local {

	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;
	import flash.events.Event;
	import flash.filesystem.File;

	public class AddDragAndDrop extends ParentWindow {

		private static var _form		:Form = new Form(530);
		private static var _check		:ModalCheckbox = new ModalCheckbox(true);			

		public function AddDragAndDrop()
		{
			super.addCloseButton();
			super.title = 'New Bookmark';
			super.drawBackground(550, 210);
			addOkButton();
			addNoButton();
			
			_form.fields = [{label:'Name'}, {label:'Location', enabled:false}];
			_form.y = 70; 
			addChild(_form);
			
			_check.y = 170; 
			_check.label = 'Autosave Every 60 Minutes';
			addChild(_check);
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
			addEventListener(UIEvent.NO_BUTTON, onNoButton);
		}

		public function set file(f:File):void
		{
			parseTargetNameAndLocation(f);
		}

		private function parseTargetNameAndLocation($file:File):void
		{
			var p:String = $file.nativePath;
		// get the name of the file off the end of the file path //	
			var n:String = p.substr(p.lastIndexOf('/') + 1);
		// if we get a file, strip off the file extension //	
			if (!$file.isDirectory) n = n.substr(0, n.lastIndexOf('.'));
			_form.setField(0, n.substr(0,1).toUpperCase() + n.substr(1));
			_form.setField(1, p);
		}
		
		private function onOkButton(e:Event):void 
		{	
			var m:String = Bookmark.validate(_form.getField(0), _form.getField(1));
			if (m == '') {
				initNewBookmark();
			}	else{
				AppModel.alert(new Message(m));
			}
		}
		
		private function onNoButton(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}			
		
		private function initNewBookmark():void
		{
			var b:Boolean = new File('file://'+_form.getField(1)).isDirectory;
			var o:Object = {
				label		:	_form.getField(0),
				type		: 	b ? Bookmark.FOLDER : Bookmark.FILE,
				path		:	_form.getField(1),
				active 		:	1,
				autosave	:	_check.selected ? 60 : 0
			};		
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));						
			AppModel.engine.addBookmark(new Bookmark(o));
		}
		
	}
	
}
