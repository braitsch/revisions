package view.modals {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.FileBrowser;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class NewBookmark extends ModalWindow {

		private static var _view		:NewBookmarkMC = new NewBookmarkMC();
		private static var _browser		:FileBrowser = new FileBrowser();		

		public function NewBookmark()
		{
			addChild(_view);
			super.addCloseButton();			
			super.addButtons([_view.file_btn, _view.folder_btn, _view.github_btn, _view.beanstalk_btn, _view.private_btn]);			
			_view.addEventListener(MouseEvent.CLICK, onButtonClick);
			_browser.addEventListener(UIEvent.FILE_BROWSER_SELECTION, onFileSelection);			
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch(e.target){
				case _view.file_btn :
					_browser.browseForFile('Select a file to track.');
				break;	
				case _view.folder_btn :
					_browser.browseForDirectory('Select a folder to track.');
				break;	
				case _view.github_btn :
			//		dispatchEvent(new UIEvent(UIEvent.SHOW_LOGIN, new RemoteAccount(RemoteAccount.GITHUB)));
					dispatchMessage('GitHub integration is coming in the next build.');
				break;	
				case _view.beanstalk_btn :
			//		dispatchEvent(new UIEvent(UIEvent.SHOW_LOGIN, new RemoteAccount(RemoteAccount.BEANSTALK)));
					dispatchMessage('Beanstalk integration is coming in the next build.');
				break;	
				case _view.private_btn :
					dispatchMessage('Private repositories will be supported in the next build.');
				break;																	
			}
		}
		
		private function onFileSelection(e:UIEvent):void
		{
			AppModel.engine.dispatchEvent(new UIEvent(UIEvent.DRAG_AND_DROP, e.data as File));
		}		
		
		private function dispatchMessage(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}	
		
	}
	
}
