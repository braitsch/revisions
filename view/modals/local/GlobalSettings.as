package view.modals.local {

	import system.StringUtils;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.AppSettings;
	import system.LicenseManager;
	import view.modals.base.ModalWindow;
	import view.modals.system.Message;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import mx.utils.StringUtil;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GlobalSettings extends ModalWindow {

		private static var _view		:GlobalSettingsMC = new GlobalSettingsMC();
		private static var _form		:Form = new Form(new Form3());
		private static var _checks		:Vector.<ModalCheckbox> = new Vector.<ModalCheckbox>();
		private static var _labels		:Vector.<String> = new <String>[
												'Automatically check for updates',
												'Show tooltips',
												'Prompt before downloading a previous version',
												'Start Revisions on system startup'	];

		public function GlobalSettings()
		{
			addChild(_view);
			super.addCloseButton();	
			super.drawBackground(550, 285);
			super.setTitle(_view, 'Global Settings');
			super.defaultButton = _view.ok_btn;
			
			_form.labels = ['Name', 'Email', 'License Key'];
			_form.enabled = [1, 2];
			_form.y = 70; _view.addChildAt(_form, 0);
			
			attachOptions();
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
		}

		private function attachOptions():void
		{
			for (var i:int = 0; i < 4; i++) {
				var k:ModalCheckbox = new ModalCheckbox(true);
				k.label = _labels[i];
				k.addEventListener(MouseEvent.CLICK, onCheckboxSelection);
				k.y = 185 + (20 * i);
				addChild(k);
				_checks.push(k);
			}
		}

		override protected function onAddedToStage(e:Event):void
		{
			_form.setField(0, AppModel.proxies.config.userName);
			_form.setField(1, AppModel.proxies.config.userEmail);
			_form.setField(2, LicenseManager.key);
			_checks[0].selected = AppSettings.getSetting(AppSettings.CHECK_FOR_UPDATES);
			_checks[1].selected = AppSettings.getSetting(AppSettings.SHOW_TOOL_TIPS);
			_checks[2].selected = AppSettings.getSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD);
			_checks[3].selected = AppSettings.getSetting(AppSettings.START_AT_LOGIN);
			AppModel.proxies.config.addEventListener(AppEvent.GIT_SETTINGS, onGitSettings);
			super.onAddedToStage(e);
		}

		private function onGitSettings(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.config.removeEventListener(AppEvent.GIT_SETTINGS, onGitSettings);			
		}
		
		private function onCheckboxSelection(e:MouseEvent):void
		{
			switch(e.currentTarget){
				case _checks[0] :
					AppSettings.setSetting(AppSettings.CHECK_FOR_UPDATES, _checks[0].selected);
				break;
				case _checks[1] :
					AppSettings.setSetting(AppSettings.SHOW_TOOL_TIPS , _checks[1].selected);
				break;
				case _checks[2] :
					AppSettings.setSetting(AppSettings.PROMPT_BEFORE_DOWNLOAD, _checks[2].selected);
				break;
				case _checks[3] :
					AppSettings.setSetting(AppSettings.START_AT_LOGIN, _checks[3].selected);	
				break;												
			}
		}		
		
		private function onOkButton(evt:Event):void
		{
			var n:String = StringUtil.trim(_form.getField(0));
			var e:String = StringUtil.trim(_form.getField(1));
			var m:String = validateFields(n, e);
			if (m == ''){
				AppModel.proxies.config.setUserNameAndEmail(n, e);
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}	
		}
		
		private function validateFields(n:String, e:String):String
		{
			if (n == '') return 'Please enter your name.';
			if (e == '') return 'Please enter your email.';
			if (StringUtils.validateEmail(e) == false) return 'The email you entered is invalid.';
			return '';			
		}		
		
	}
	
}
