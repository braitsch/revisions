package view.modals.local {

	import events.UIEvent;
	import model.AppModel;
	import system.AppSettings;
	import view.modals.base.ModalWindow;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AppExpired extends ModalWindow {

		private static var _view	:ConfirmMC = new ConfirmMC();

		public function AppExpired()
		{
			addChild(_view);
			super.drawBackground(550, 210);
			super.setTitle(_view, 'Trial Expired');			
			super.addButtons([_view.cancel_btn]);
			super.defaultButton = _view.ok_btn;
			_view.textArea.message_txt.text = 'This beta version of Revisions has expired.\n';
			_view.textArea.message_txt.text+= 'Please update to the most current version.';
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
			addEventListener(UIEvent.ENTER_KEY, onCheckForUpdates);
		}

		private function onCancel(e:MouseEvent):void
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
