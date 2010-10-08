package view.modals {
	import commands.UICommand;

	import model.AppModel;

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
			
			_view.add_btn.addEventListener(MouseEvent.CLICK, onAddRepository);
			_view.browse_btn.addEventListener(MouseEvent.CLICK, showFileBrowser);
						_browser.addEventListener(UICommand.FILE_BROWSER_SELECTION, onFileSelection);	
		}

		public function set local($local:String):void
		{
			if (!super.isValidTarget($local, _view.local_txt)) return;
			_view.local_txt.text = $local;
		// autoset the name field when user drops new repo on the application	
			var n:String = $local.substring($local.lastIndexOf('/')+1);
			_view.name_txt.text = n.substr(0,1).toUpperCase()+n.substr(1);
		}

		private function showFileBrowser(e:MouseEvent):void 
		{
			_browser.browse('Please Select A Directory');			
		}
		
		private function onFileSelection(e:UICommand):void 
		{
			if (!super.isValidTarget(e.data as String, _view.local_txt)) return;			
			_view.local_txt.text = e.data as String;				
		}
		
		private function onAddRepository(e:MouseEvent):void 
		{	
			if (!validate()) return;
			AppModel.editor.initRepository(_view.local_txt.text);				
			AppModel.database.addRepository(_view.name_txt.text, _view.local_txt.text);					
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
		}	
		
		private function validate():Boolean
		{
			//TODO need to check against existing repo names and locations to prevent duplicates 
			var b:Boolean = true;
			if (_view.name_txt.text=='' || _view.name_txt.text=='Please Enter A Name'){
				_view.name_txt.text = 'Please Enter A Name';
				b = false;			}	
			try{
				new File('file://'+_view.local_txt.text);
			}	catch(e:ArgumentError){
				_view.local_txt.text = 'Selected Target Is Not Valid';
				b = false;
			}
			return b;
		}
				
	}
	
}
