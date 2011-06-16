package view.modals {

	import model.AppModel;
	import model.db.AppSettings;
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;

	public class AppExpired extends ModalWindow {

		private static var _view	:WindowExpiredMC = new WindowExpiredMC();

		public function AppExpired()
		{
			addChild(_view);
			_view.message_txt.text = 'This beta version of Revisions has expired.\n';
			_view.message_txt.text+= 'Please update to the most current version.';
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onCheckForUpdates);
			super.addButtons([_view.cancel_btn, _view.ok_btn]);
		}

		private function onCancel(e:MouseEvent):void
		{
			NativeApplication.nativeApplication.exit();			
		}
		
		private function onCheckForUpdates(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, 'true');			
			AppModel.updater.checkForUpdate();	
		}
		
	}
	
}
