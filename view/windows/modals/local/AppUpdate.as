package view.windows.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.AppSettings;
	import view.ui.ModalCheckbox;
	import view.windows.base.ParentWindow;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;

	public class AppUpdate extends ParentWindow {

		private static var _view	:AppUpdateMC = new AppUpdateMC();
		private static var _check	:ModalCheckbox = new ModalCheckbox(false);

		public function AppUpdate()
		{
			addChild(_view);
			super.drawBackground(550, 240);
			super.title = 'Update Available';
			addCheckBox();
			addNoButton('Skip', 285, 190);
			addOkButton('Download', 415, 190);
			addEventListener(UIEvent.ENTER_KEY, onDownload);
			addEventListener(UIEvent.NO_BUTTON, onSkipUpdate);
		}

		private function addCheckBox():void
		{
			_check.y = 195; 
			_check.label = "Don't prompt me to update again.";
			_check.addEventListener(MouseEvent.CLICK, onCheckbox);
			addChild(_check);
		}

		public function set newVersion(n:String):void
		{
			_view.textArea.message_txt.text = "Revisions "+n+" is now available!\n";
			_view.textArea.message_txt.text+= "Would you like to update to this latest version?";
		}
		
		private function onCheckbox(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, !_check.selected);
		}		
		
		private function onSkipUpdate(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.APP_UPDATE_IGNORED));
		}

		private function onDownload(e:UIEvent):void
		{
			disableButtons();
			_view.textArea.message_txt.text = "Downloading Update..";
			AppModel.updater.updateApplication();
			AppModel.engine.addEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateError);
			AppModel.engine.addEventListener(AppEvent.APP_UPDATE_PROGRESS, onUpdateProgress);
			AppModel.engine.addEventListener(AppEvent.APP_UPDATE_COMPLETE, onUpdateComplete);
		}
		
		private function disableButtons():void
		{
			super.okButton.enabled = false;
			super.noButton.enabled = false;
			removeEventListener(UIEvent.ENTER_KEY, onDownload);
			removeEventListener(UIEvent.NO_BUTTON, onSkipUpdate);			
		}

		private function onUpdateError(e:AppEvent):void
		{
			_view.textArea.message_txt.text = "Whoops! Something Went Wrong.\nMaybe quit and restart?";			
			_view.textArea.message_txt.text+= e.data;
		}
		
		private function onUpdateProgress(e:AppEvent):void
		{
			var p:ProgressEvent = e.data as ProgressEvent;
			var n:String = ((p.bytesLoaded / p.bytesTotal) * 100).toFixed(2);
			_view.textArea.message_txt.text = "Downloading Update.. "+n+'%';
		}
		
		private function onUpdateComplete(e:AppEvent):void
		{
			_view.textArea.message_txt.text = "Download Complete.\n";			
			_view.textArea.message_txt.text+= "Preparing For Install.";			
		}
		
	}
	
}
