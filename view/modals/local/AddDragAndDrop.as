package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindow;
	import view.modals.system.Message;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.events.Event;
	import flash.filesystem.File;

	public class AddDragAndDrop extends ModalWindow {

		private static var _view		:DragAndDropMC = new DragAndDropMC();
		private static var _form		:Form = new Form(new Form2());
		private static var _check		:ModalCheckbox = new ModalCheckbox(true);			

		public function AddDragAndDrop()
		{
			addChild(_view);
			addChild(_check);
			super.addCloseButton();
			super.drawBackground(550, 210);
			super.setTitle(_view, 'New Bookmark');
			super.defaultButton = _view.ok_btn;
			
			_form.labels = ['Name', 'Location'];
			_form.enabled = [1];
			_form.y = 70; _view.addChildAt(_form, 0);
			
			_check.y = 170; 
			_check.label = 'Autosave Every 60 Minutes';
		//	_view.name_txt.text = _view.local_txt.text = ''; 
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
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
			_view.local_txt.text = p;
			_view.name_txt.text = n.substr(0,1).toUpperCase() + n.substr(1);
		}			
		
		private function onOkButton(e:Event):void 
		{	
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text);
			if (m == '') {
				initNewBookmark();
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}
		}	
		
		private function initNewBookmark():void
		{
			var b:Boolean = new File('file://'+_view.local_txt.text).isDirectory;
			var o:Object = {
				label		:	_view.name_txt.text,
				type		: 	b ? Bookmark.FOLDER : Bookmark.FILE,
				path		:	_view.local_txt.text,
				active 		:	1,
				autosave	:	_check.selected ? 60 : 0
			};		
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));						
			AppModel.engine.addBookmark(new Bookmark(o));
		}
		
	}
	
}
