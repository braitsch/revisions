package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindowForm;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class AddDragAndDrop extends ModalWindowForm {

		private static var _view		:DragAndDropMC = new DragAndDropMC();
		private static var _check		:ModalCheckbox = new ModalCheckbox(_view.check, true);			

		public function AddDragAndDrop()
		{
			super(_view);
			super.addCloseButton();
			super.drawBackground(550, 210);
			super.setTitle(_view, 'New Bookmark');
			super.defaultButton = _view.ok_btn;
			super.labels = ['Name', 'Location'];
			super.inputs = Vector.<TLFTextField>([_view.name_txt]);
			_check.label = 'Autosave Every 60 Minutes';
			_view.name_txt.text = _view.local_txt.text = ''; 
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
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
		
		override public function onEnterKey():void { onOkButton(); }		
		private function onOkButton(e:MouseEvent = null):void 
		{	
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text);
			if (m == '') {
				initNewBookmark();
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
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
