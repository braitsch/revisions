package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppEngine;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.FileBrowser;
	import com.adobe.crypto.MD5;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class NewBookmark extends ModalWindow {

		private static var _path		:String;
		private static var _view		:NewBookmarkMC = new NewBookmarkMC();
		private static var _browser		:FileBrowser = new FileBrowser();

		public function NewBookmark()
		{
			addChild(_view);
			_view.name_txt.text = _view.local_txt.text = ''; 
			_view.browse_btn.addEventListener(MouseEvent.CLICK, showFileBrowser);
			_view.action_btn.addEventListener(MouseEvent.CLICK, onActionButtonClick);
			_view.github.addEventListener(MouseEvent.CLICK, onGitHub); 
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalk);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileBrowserSelection);
			super.addButtons([_view.action_btn, _view.browse_btn, _view.github, _view.beanstalk]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
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
			_path = $file.nativePath;
			_view.local_txt.text = _path;
			var name:String = _path.substr(_path.lastIndexOf('/')+1);
			if (!$file.isDirectory) name = name.substr(0, name.lastIndexOf('.'));
			_view.name_txt.text = name.substr(0,1).toUpperCase() + name.substr(1);			
		}		
		
		private function onActionButtonClick(e:MouseEvent):void 
		{	
			if (validate()) initNewBookmark();
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
			var o:Object = {
				label	:	_view.name_txt.text,
				path	:	_path,
				remote 	:	null,
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
				showUserError('Project name cannot be empty.');
				return false;			
			}
			if (p == '') {
				showUserError('Selected target is not valid.');
				return false;			
			}
			if (p == '/') {
				showUserError('Tracking the ENTIRE file system is not supported, sorry dude.');
				return false;			
			}			
			var f:File = new File('file://'+_path);
			if (!f.exists){
				showUserError('Target not found.\nPlease check the file path.');
				return false;
			}	
			var b:Vector.<Bookmark> = AppEngine.bookmarks;
			for (var i:int = 0; i < b.length; i++) {
				if (n == b[i].label) {
					showUserError('The name '+b[i].label+' is already taken.\nPlease choose something else.');
					return false;				}	else if (MD5.hash(p) == MD5.hash(b[i].path)){
					var w:String = p.substr(p.lastIndexOf('/')+1);
					var k:String = f.isDirectory ? 'folder' : 'file';
					showUserError('The '+k+' '+w+' is already being tracked by the bookmark '+b[i].label);
					return false;					
				}
			}
			return true;
		}
		
		private function showUserError(m:String):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
		}
				
	}
	
}
