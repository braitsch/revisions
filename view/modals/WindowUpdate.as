package view.modals {

	import flash.events.ProgressEvent;
	import events.InstallEvent;
	import model.db.AppSettings;
	import model.AppModel;
	import events.UIEvent;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class WindowUpdate extends ModalWindow {

		private static var _view	:WindowUpdateMC = new WindowUpdateMC();
		private static var _check1	:ModalCheckbox = new ModalCheckbox(_view.check1, false);

		public function WindowUpdate()
		{
			addChild(_view);
			_check1.label = "Don't prompt me to update again.";
			_view.check1.addEventListener(MouseEvent.CLICK, onCheckbox);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
			_view.download_btn.addEventListener(MouseEvent.CLICK, onDownload);
			super.addButtons([_view.cancel_btn, _view.download_btn]);
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
		
		private function onCancel(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}

		private function onDownload(e:MouseEvent):void
		{
			_view.message_txt.text = "Downloading Update..";
			AppModel.updater.updateApplication();
			AppModel.updater.addEventListener(InstallEvent.UPDATE_ERROR, onUpdateError);
			AppModel.updater.addEventListener(InstallEvent.UPDATE_PROGRESS, onUpdateProgress);
			AppModel.updater.addEventListener(InstallEvent.UPDATE_COMPLETE, onUpdateComplete);
		}

		private function onUpdateError(e:InstallEvent):void
		{
			_view.message_txt.text = "Whoops! Something Went Wrong.";			
			_view.message_txt.text+= e.data;
		}
		
		private function onUpdateProgress(e:InstallEvent):void
		{
			var p:ProgressEvent = e.data as ProgressEvent;
			var n:String = ((p.bytesLoaded / p.bytesTotal) * 100).toFixed(2);
			_view.message_txt.text = "Downloading Update.. "+n+'%';
		}
		
		private function onUpdateComplete(e:InstallEvent):void
		{
			_view.message_txt.text = "Download Complete.\n";			
			_view.message_txt.text+= "Preparing For Install.";			
		}
		
		
	}
	
}
