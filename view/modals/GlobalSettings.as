package view.modals {

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
		private static var _check2		:ModalCheckbox = new ModalCheckbox(_view.check2, true);		
		private static var _check3		:ModalCheckbox = new ModalCheckbox(_view.check3, true);		

		public function GlobalSettings()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.email_txt]));
			_check1.label = 'Automatically check for updates';
			_check2.label = 'Show tooltips';
			_check3.label = 'Prompt before downloading a previous revision';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOk);
			_view.check1.addEventListener(MouseEvent.CLICK, onCheck1);
			_view.check2.addEventListener(MouseEvent.CLICK, onCheck2);
			_view.check3.addEventListener(MouseEvent.CLICK, onCheck3);
			AppModel.settings.addEventListener(InstallEvent.APP_SETTINGS, onUserSettings);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_IS_READY, onGitSettings);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_SETTINGS, onGitSettings);
		}

		private function onUserSettings(e:InstallEvent):void
		{
			_check1.selected = AppSettings.getSetting(AppSettings.IGNORE_UPDATES) == 'true';
			_check2.selected = AppSettings.getSetting(AppSettings.SHOW_TOOL_TIPS) == 'true';
			_check3.selected = AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD) == 'true';
		}

		private function onGitSettings(e:InstallEvent):void
		{
			_view.name_txt.text = AppModel.proxies.config.userName;
			_view.email_txt.text = AppModel.proxies.config.userEmail;
			_view.license_txt.text = LicenseManager.key;
		}
		
		private function onCheck1(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.IGNORE_UPDATES, _check1.selected);
		}
		
		private function onCheck2(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.SHOW_TOOL_TIPS , _check2.selected);
		}

		private function onCheck3(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD, _check3.selected);
		}
		
		private function onOk(e:MouseEvent):void
		{
			AppModel.proxies.config.userName = _view.name_txt.text;
			AppModel.proxies.config.userEmail = _view.email_txt.text;
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}
		
	}
	
}
