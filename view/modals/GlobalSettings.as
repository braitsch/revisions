package view.modals {

	import events.BookmarkEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.db.AppSettings;
	import flash.events.MouseEvent;

	public class GlobalSettings extends ModalWindow {

		private static var _view		:GlobalSettingsMC = new GlobalSettingsMC();

	//TODO add 'prompt for download' checkbox into view to change global setting
		public function GlobalSettings()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn]);
			super.addCheckboxes([_view.check1]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.email_txt]));
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOk);
			_view.check1.addEventListener(MouseEvent.CLICK, onCheckboxSelected);
			AppModel.settings.addEventListener(InstallEvent.SETTINGS, onUserSettings);
			AppModel.proxies.config.addEventListener(BookmarkEvent.SET_USERNAME, onUserInfo);
		}

		private function onUserSettings(e:InstallEvent):void
		{
			_view.check1.cross.visible = AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES) == 'true';
		}

		private function onUserInfo(e:BookmarkEvent):void
		{
			_view.name_txt.text = AppModel.proxies.config.userName;
			_view.email_txt.text = AppModel.proxies.config.userEmail;
			_view.license_txt.text = '56afea94f7c9cda8f96b6cebe53023c64d157a9f';
		}
		
		private function onCheckboxSelected(e:MouseEvent):void
		{
			_view.check1.cross.visible = !_view.check1.cross.visible;
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, _view.check1.cross.visible);
		}

		private function onOk(e:MouseEvent):void
		{
		//TODO write username & email to git global config //
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}
		
	}
	
}
