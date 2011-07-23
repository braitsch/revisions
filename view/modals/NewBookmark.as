package view.modals {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class NewBookmark extends ModalWindow {

		private static var _view	:NewBookmarkMC = new NewBookmarkMC();

		public function NewBookmark()
		{
			addChild(_view);
			super.addCloseButton();			
			super.addButtons([_view.file_btn, _view.folder_btn, _view.github_btn, _view.beanstalk_btn, _view.private_btn]);			
			_view.addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);				
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch(e.target){
				case _view.file_btn :
					super.browseForFile('Select a file to track.');
				break;	
				case _view.folder_btn :
					super.browseForDirectory('Select a folder to track.');
				break;	
				case _view.github_btn :
					if (AccountManager.github){
						dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
					}	else{
						dispatchEvent(new UIEvent(UIEvent.GITHUB_LOGIN));
					}
				break;	
				case _view.beanstalk_btn :
					dispatchAlert('Beanstalk integration is coming in the next build.');
			//		dispatchEvent(new UIEvent(UIEvent.SHOW_LOGIN, new RemoteAccount(RemoteAccount.BEANSTALK)));
				break;	
				case _view.private_btn :
					dispatchAlert('Private repositories will be supported in the next build.');
				break;																	
			}
		}
		
		private function onBrowserSelection(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.DRAG_AND_DROP, e.data as File));
		}			
		
		private function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}	
		
	}
	
}
