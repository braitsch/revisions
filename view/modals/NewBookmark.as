package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.FileBrowser;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class NewBookmark extends ModalWindow {

		private static var _view		:NewBookmarkMC = new NewBookmarkMC();
		private static var _browser		:FileBrowser = new FileBrowser();
		private static var _check1		:ModalCheckbox = new ModalCheckbox(_view.check1, true);		

		public function NewBookmark()
		{
			addChild(_view);
			_check1.label = 'Autosave Every 60 Minutes';			
			_view.name_txt.text = _view.local_txt.text = ''; 
			_view.addFile.addEventListener(MouseEvent.CLICK, showFileBrowser);
			_view.addFolder.addEventListener(MouseEvent.CLICK, showFileBrowser);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.github.addEventListener(MouseEvent.CLICK, onGitHub); 
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalk);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileSelection);
			super.addButtons([_view.ok_btn, _view.addFile, _view.addFolder, _view.github, _view.beanstalk]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
		}

		override public function onEnterKey():void
		{
			onOkButton();
		}
		
		public function reset():void
		{
			toggleButtons(true);
		}

		public function addNewFromDropppedFile($file:File):void
		{
			toggleButtons(false);
			parseTargetNameAndLocation($file);	
		}
		
	// adding a new bookmark from the file browser //	

		private function showFileBrowser(e:MouseEvent):void 
		{
			if (e.target == _view.addFile){
				_browser.browseForFile("Select A File To Start Tracking");
			}	else if (e.target == _view.addFolder){
				_browser.browseForDirectory("Select A Folder To Start Tracking");
			}
		}
		
		private function toggleButtons(reset:Boolean):void
		{
			_view.ok_btn.visible = !reset;
			_view.addFile.visible = _view.addFolder.visible = reset;
		}
		
		private function onFileSelection(e:UIEvent):void 
		{
			toggleButtons(false);
			parseTargetNameAndLocation(e.data as File);
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
		
		private function onOkButton(e:MouseEvent = null):void 
		{	
			var m:String = Bookmark.validate(_view.name_txt.text, _view.local_txt.text);
			if (m == '') {
				initNewBookmark();
			}	else{
				toggleButtons(true);
				dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
			}
		}
		
		private function onGitHub(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'GitHub & Beanstalk integration is coming in the next build.'));
		}	
		
		private function onBeanstalk(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, 'GitHub & Beanstalk integration is coming in the next build.'));
		}
		
		private function initNewBookmark():void
		{
			var b:Boolean = new File('file://'+_view.local_txt.text).isDirectory;
			var o:Object = {
				label		:	_view.name_txt.text,
				type		: 	b ? Bookmark.FOLDER : Bookmark.FILE,
				path		:	_view.local_txt.text,
				remote 		:	null,
				active 		:	1,
				autosave	:	_check1.selected ? 60 : 0
			};		
			AppModel.engine.addBookmark(new Bookmark(o));
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));						
		}		
		
	}
	
}
