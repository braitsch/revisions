package view.modals {

	import events.BookmarkEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.db.AppSettings;
	import system.LicenseManager;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class GlobalSettings extends ModalWindow {

		private static var _view		:GlobalSettingsMC = new GlobalSettingsMC();
		private static var _check1		:ModalCheckbox = new ModalCheckbox(_view.check1, true);

	//TODO add 'prompt for download' checkbox into view to change global setting
		public function GlobalSettings()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.email_txt]));
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOk);
			_check1.label = 'Automatically Check for Updates';
			_check1.addEventListener(MouseEvent.CLICK, onCheckbox);
			AppModel.settings.addEventListener(InstallEvent.SETTINGS, onUserSettings);
			AppModel.proxies.config.addEventListener(BookmarkEvent.SET_USERNAME, onUserInfo);
		}

		private function onUserSettings(e:InstallEvent):void
		{
			_check1.selected = AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES) == 'true';
		}

		private function onUserInfo(e:BookmarkEvent):void
		{
			_view.name_txt.text = AppModel.proxies.config.userName;
			_view.email_txt.text = AppModel.proxies.config.userEmail;
			_view.license_txt.text = LicenseManager.key;
		}
		
		private function onCheckbox(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, _check1.selected);
		}

		private function onOk(e:MouseEvent):void
		{
		//TODO write username & email to git global config //
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}
		
	}
	
}
