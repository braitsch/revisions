package view.windows.modals.local {

	import events.UIEvent;
	import model.AppModel;
	import system.AppSettings;
	import view.windows.base.ParentWindow;
	import flash.desktop.NativeApplication;
	import flash.events.Event;

	public class AppExpired extends ParentWindow {

		private static var _view	:ConfirmMC = new ConfirmMC();

		public function AppExpired()
		{
			addChild(_view);
			super.title = 'Trial Expired';
			super.drawBackground(550, 250);
			addOkButton('OK', 415, 200);
			addNoButton('Cancel', 285, 200);
			_view.textArea.message_txt.text = 'This beta version of Revisions has expired.\n';
			_view.textArea.message_txt.text+= 'Please update to the most current version.';
			addEventListener(UIEvent.ENTER_KEY, onCheckForUpdates);
			addEventListener(UIEvent.NO_BUTTON, onCloseApplication);
		}

		private function onCloseApplication(e:UIEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function onCheckForUpdates(e:Event):void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, true);			
			AppModel.updater.checkForUpdate();	
		}
		
	}
	
}
