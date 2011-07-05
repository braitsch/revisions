package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.db.AppSettings;
	import system.LicenseManager;
	import view.ui.ModalCheckbox;
	import mx.utils.StringUtil;
	import flash.events.Event;
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
			_check3.label = 'Prompt before downloading a previous version';
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOk);
			_view.check1.addEventListener(MouseEvent.CLICK, onCheck1);
			_view.check2.addEventListener(MouseEvent.CLICK, onCheck2);
			_view.check3.addEventListener(MouseEvent.CLICK, onCheck3);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			AppModel.settings.addEventListener(InstallEvent.APP_SETTINGS, onUserSettings);
		}

		private function onAddedToStage(e:Event):void
		{
			_view.license_txt.text = LicenseManager.key;
			_view.name_txt.text = AppModel.proxies.config.userName;
			_view.email_txt.text = AppModel.proxies.config.userEmail;
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_SETTINGS, onGitSettings);
		}

		private function onUserSettings(e:InstallEvent):void
		{
			_check1.selected = AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES);
			_check2.selected = AppSettings.getSetting(AppSettings.SHOW_TOOL_TIPS);
			_check3.selected = AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD);
		}

		private function onGitSettings(e:InstallEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.config.removeEventListener(InstallEvent.GIT_SETTINGS, onGitSettings);			
		}
		
		private function onCheck1(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, _check1.selected);
		}
		
		private function onCheck2(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.SHOW_TOOL_TIPS , _check2.selected);
		}

		private function onCheck3(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD, _check3.selected);
		}
		
		private function onOk(evt:MouseEvent):void
		{
			var n:String = StringUtil.trim(_view.name_txt.text);
			var e:String = StringUtil.trim(_view.email_txt.text);
			var m:String = NameAndEmail.validate(n, e);
			if (m == ''){
				AppModel.proxies.config.setUserNameAndEmail(n, e);
			}	else{
				AppModel.engine.dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
			}	
		}
		
	}
	
}
