package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import view.modals.ModalWindow;

	public class NewBookmark extends ModalWindow {

		private static var _view	:NewBookmarkMC = new NewBookmarkMC();

		public function NewBookmark()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 240);
			super.setTitle(_view, 'New Bookmark');
			super.setHeading(_view, 'Select below to track a new file, folder, or checkout from a remote repository.');
			super.addButtons([_view.file_btn, _view.folder_btn, _view.github_btn, _view.beanstalk_btn, _view.private_btn]);			
			_view.addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch(e.target){
				case _view.file_btn :
					super.browseForFile('Select a file to track');
				break;	
				case _view.folder_btn :
					super.browseForDirectory('Select a folder to track');
				break;	
				case _view.github_btn :
					onGitHubClick();
				break;	
				case _view.beanstalk_btn :
					onBeanStalkClick();
				break;	
				case _view.private_btn :
					dispatchAlert('Private repositories will be supported in the next build.');
				break;																	
			}
		}

		private function onBeanStalkClick():void
		{
			dispatchAlert('Beanstalk integration is coming in the next build.');
		//	dispatchEvent(new UIEvent(UIEvent.REMOTE_LOGIN, {type:RemoteAccount.BEANSTALK, event:UIEvent.ABOUT_GIT}));			
		}
		
		private function onGitHubClick():void
		{
			if (AccountManager.github){
				dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.REMOTE_LOGIN, {type:RemoteAccount.GITHUB, event:UIEvent.GITHUB_HOME}));
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
