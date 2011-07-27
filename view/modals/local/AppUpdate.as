package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import model.AppModel;
	import model.db.AppSettings;
	import view.modals.ModalWindow;
	import view.ui.ModalCheckbox;

	public class AppUpdate extends ModalWindow {

		private static var _view	:WindowUpdateMC = new WindowUpdateMC();
		private static var _check1	:ModalCheckbox = new ModalCheckbox(_view.check1, false);

		public function AppUpdate()
		{
			addChild(_view);
			super.addButtons([_view.skip_btn, _view.download_btn]);
			_check1.label = "Don't prompt me to update again.";
			_view.check1.addEventListener(MouseEvent.CLICK, onCheckbox);
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipUpdate);
			_view.download_btn.addEventListener(MouseEvent.CLICK, onDownload);
		}

		public function set newVersion(n:String):void
		{
			_view.message_txt.text = "Revisions "+n+" is now available!\n";
			_view.message_txt.text+= "Would you like to update to this latest version?";
		}
		
		private function onCheckbox(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, !_check1.selected);
		}		
		
		private function onSkipUpdate(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.updater.dispatchEvent(new AppEvent(AppEvent.APP_UPDATE_IGNORED));
		}

		private function onDownload(e:MouseEvent):void
		{
			_view.message_txt.text = "Downloading Update..";
			super.enableButton(_view.skip_btn, false);
			super.enableButton(_view.download_btn, false);			
			AppModel.updater.updateApplication();
			AppModel.updater.addEventListener(AppEvent.APP_UPDATE_FAILURE, onUpdateError);
			AppModel.updater.addEventListener(AppEvent.APP_UPDATE_PROGRESS, onUpdateProgress);
			AppModel.updater.addEventListener(AppEvent.APP_UPDATE_COMPLETE, onUpdateComplete);
		}

		private function onUpdateError(e:AppEvent):void
		{
			_view.message_txt.text = "Whoops! Something Went Wrong.";			
			_view.message_txt.text+= e.data;
		}
		
		private function onUpdateProgress(e:AppEvent):void
		{
			var p:ProgressEvent = e.data as ProgressEvent;
			var n:String = ((p.bytesLoaded / p.bytesTotal) * 100).toFixed(2);
			_view.message_txt.text = "Downloading Update.. "+n+'%';
		}
		
		private function onUpdateComplete(e:AppEvent):void
		{
			_view.message_txt.text = "Download Complete.\n";			
			_view.message_txt.text+= "Preparing For Install.";			
		}
		
	}
	
}
