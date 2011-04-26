package view.modals {

	import events.UIEvent;
	import model.AppEngine;
	import model.AppModel;
	import model.Bookmark;
	import utils.FileBrowser;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;

	public class AddBookmark extends ModalWindow {

		private static var _view		:AddBookmarkMC = new AddBookmarkMC();
		private static var _browser		:FileBrowser = new FileBrowser();

		public function AddBookmark()
		{
			addChild(_view);
			super.cancel = _view.cancel_btn;
			super.addInputs(Vector.<TextField>([_view.name_txt, _view.local_txt]));			
			super.addButtons([_view.add_btn, _view.browse_btn, _view.cancel_btn]);
			
			_view.add_btn.addEventListener(MouseEvent.CLICK, onDirectorySelected);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, showFileBrowser);
						_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileSelection);	
		}

		public function set local($local:String):void
		{
			_view.local_txt.text = $local;
			_view.name_txt.text = getNameOfDirectory($local);
		}
		
		private function getNameOfDirectory($path:String):String
		{
			var n:String = $path.substring($path.lastIndexOf('/')+1);
			return n.substr(0,1).toUpperCase() + n.substr(1);				
		}

		private function showFileBrowser(e:MouseEvent):void 
		{
			_browser.browse('Please Select A Directory');			
		}
		
		private function onFileSelection(e:UIEvent):void 
		{
			_view.local_txt.text = e.data as String;				
		}
		
		private function onDirectorySelected(e:MouseEvent):void 
		{	
			if (!validate()) return;
			AppModel.engine.addBookmark(new Bookmark(_view.name_txt.text, _view.local_txt.text, true));
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
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
				showUserError('Selected Folder Is Not Valid');
				return false;			
			}
			if (p == '/') {
				showUserError('Tracking The ENTIRE File System Is Not Supported, Sorry.');
				return false;			
			}			
			var f:File;
			try {
				f = new File('file://'+_view.local_txt.text);
			}
			catch(e:Error){
				showUserError('Target Not Found<br>Please Check The Folder Path');
				return false;				
			}
			if (!f.exists){
				showUserError('Target Not Found<br>Please Check The Folder Path');
				return false;
			}	
			if (!f.isDirectory){
				showUserError('New Projects Must Target A Folder');
				return false;
			}						
			var b:Vector.<Bookmark> = AppEngine.bookmarks;
			for (var i:int = 0; i < b.length; i++) {
				if (n == b[i].label) {
					showUserError('Project Name <b>'+b[i].label+'</b> Is Already Taken');
					return false;				}	else if (p == b[i].local){
					showUserError('The Folder At <b>'+b[i].local+'</b> Is Already Being Tracked By Project '+b[i].label);
					return false;
				}
			}
			return true;
		}
		
		private function showUserError(m:String):void
		{
			dispatchEvent(new UIEvent(UIEvent.USER_ERROR, m));
		}
				
	}
	
}
