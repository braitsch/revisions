package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppEngine;
	import model.AppModel;
	import model.Bookmark;
	import utils.FileBrowser;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class NewBookmark extends ModalWindow {

		private static var _target		:String;
		private static var _view		:NewBookmarkMC = new NewBookmarkMC();
		private static var _browser		:FileBrowser = new FileBrowser();

		public function NewBookmark()
		{
			addChild(_view);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, showFileBrowser);
			_view.action_btn.addEventListener(MouseEvent.CLICK, onActionButtonClick);
			super.addButtons([_view.action_btn, _view.browse_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
			
			_view.github.over.alpha = _view.beanstalk.over.alpha = 0;
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileBrowserSelection);
		}

		public function addNewFromDropppedFile($file:File):void
		{
			parseTargetNameAndLocation($file);	
		}
		
	// adding a new bookmark from the file browser //	

		private function showFileBrowser(e:MouseEvent):void 
		{
			_browser.browse("Select A File or Folder To Start Tracking");			
		}
		
		private function onFileBrowserSelection(e:UIEvent):void 
		{
			parseTargetNameAndLocation(e.data as File);
		}
		
		private function parseTargetNameAndLocation($file:File):void
		{
			_target = $file.nativePath;
			_view.local_txt.text = _target;
			var name:String = _target.substr(_target.lastIndexOf('/')+1);
			if (!$file.isDirectory) name = name.substr(0, name.lastIndexOf('.'));
			_view.name_txt.text = name.substr(0,1).toUpperCase() + name.substr(1);			
		}		
		
		private function onActionButtonClick(e:MouseEvent):void 
		{	
			if (validate()) initNewBookmark();
		}	
		
		private function initNewBookmark():void
		{
			var o:Object = {
				label	:	_view.name_txt.text,
				target	:	_target,
				remote 	:	'',
				active 	:	1
			};				
			AppModel.engine.addBookmark(new Bookmark(o));
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));						
		}		
		
		private function validate():Boolean
		{
			var n:String = _view.name_txt.text;
			var p:String = _view.local_txt.text;
			if (n == '') {
				showUserError('Project Name Cannot Be Empty');
				return false;			
			}
			if (p == '') {
				showUserError('Selected Target Is Not Valid');
				return false;			
			}
			if (p == '/') {
				showUserError('Tracking The ENTIRE File System Is Not Supported, Sorry.');
				return false;			
			}			
			var f:File = new File('file://'+_target);
			if (!f.exists){
				showUserError('Target Not Found<br>Please Check The Path');
				return false;
			}	
			var b:Vector.<Bookmark> = AppEngine.bookmarks;
			for (var i:int = 0; i < b.length; i++) {
				if (n == b[i].label) {
					showUserError('Project Name <b>'+b[i].label+'</b> Is Already Taken');
					return false;				}
			}
			return true;
		}
		
		private function showUserError(m:String):void
		{
			trace("AddBookmark.showUserError(m)", m);
			dispatchEvent(new UIEvent(UIEvent.USER_ERROR, m));
		}
				
	}
	
}
