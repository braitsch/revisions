package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import system.AppSettings;
	import system.LicenseManager;
	import view.modals.base.ModalWindowForm;
	import view.ui.ModalCheckbox;
	import mx.utils.StringUtil;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GlobalSettings extends ModalWindowForm {

		private static var _view		:GlobalSettingsMC = new GlobalSettingsMC();
		private static var _check1		:ModalCheckbox = new ModalCheckbox(_view.check1, true);
		private static var _check2		:ModalCheckbox = new ModalCheckbox(_view.check2, true);
		private static var _check3		:ModalCheckbox = new ModalCheckbox(_view.check3, true);
		private static var _check4		:ModalCheckbox = new ModalCheckbox(_view.check4, true);

		public function GlobalSettings()
		{
			super(_view);
			super.addCloseButton();	
			super.drawBackground(550, 285);
			super.setTitle(_view, 'Global Settings');
			super.defaultButton = _view.ok_btn;
			super.labels = ['Name', 'Email', 'License Key'];
			super.inputs = Vector.<TLFTextField>([_view.name_txt, _view.email_txt]);
			_check1.label = 'Automatically check for updates';
			_check2.label = 'Show tooltips';
			_check3.label = 'Prompt before downloading a previous version';
			_check4.label = 'Start Revisions on system startup';
			_check1.addEventListener(MouseEvent.CLICK, onCheck1);
			_check2.addEventListener(MouseEvent.CLICK, onCheck2);
			_check3.addEventListener(MouseEvent.CLICK, onCheck3);
			_check4.addEventListener(MouseEvent.CLICK, onCheck4);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			AppModel.settings.addEventListener(AppEvent.APP_SETTINGS, onUserSettings);
		}

		override protected function onAddedToStage(e:Event):void
		{
			_view.license_txt.text = LicenseManager.key;
			_view.name_txt.text = AppModel.proxies.config.userName;
			_view.email_txt.text = AppModel.proxies.config.userEmail;
			AppModel.proxies.config.addEventListener(AppEvent.GIT_SETTINGS, onGitSettings);
			super.onAddedToStage(e);
		}

		private function onUserSettings(e:AppEvent):void
		{
			_check1.selected = AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES);
			_check2.selected = AppSettings.getSetting(AppSettings.SHOW_TOOL_TIPS);
			_check3.selected = AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD);
			_check4.selected = AppSettings.getSetting(AppSettings.START_AT_LOGIN);
		}

		private function onGitSettings(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.config.removeEventListener(AppEvent.GIT_SETTINGS, onGitSettings);			
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
		
		private function onCheck4(e:MouseEvent):void
		{
			AppSettings.setSetting(AppSettings.START_AT_LOGIN, _check4.selected);			
		}		
		
		override public function onEnterKey():void { onOkButton(); }		
		private function onOkButton(evt:MouseEvent = null):void
		{
			var n:String = StringUtil.trim(_view.name_txt.text);
			var e:String = StringUtil.trim(_view.email_txt.text);
			var m:String = validateFields(n, e);
			if (m == ''){
				AppModel.proxies.config.setUserNameAndEmail(n, e);
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
			}	
		}
		
		private function validateFields(n:String, e:String):String
		{
			if (n == '') return 'Please enter your name.';
			if (e == '') return 'Please enter your email.';
			if (e.indexOf('@') == -1) return 'The email you entered is invalid.';
			if (e.indexOf('.') == -1) return 'The email you entered is invalid.';
			if (e.search(/\s/g) != -1) return 'Your email cannot contain spaces.';
			return '';			
		}		
		
	}
	
}
