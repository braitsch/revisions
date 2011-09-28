package view.windows.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import mx.utils.StringUtil;
	import system.AppSettings;
	import system.LicenseManager;
	import system.StringUtils;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;

	public class GlobalSettings extends ParentWindow {

		private static var _form		:Form = new Form(530);
		private static var _okBtn		:OkButton = new OkButton();
		private static var _checks		:Vector.<ModalCheckbox> = new Vector.<ModalCheckbox>();
		private static var _labels		:Vector.<String> = new <String>[
												'Automatically check for updates',
												'Show tooltips',
												'Start Revisions on system startup'	];

		public function GlobalSettings()
		{
			super.addCloseButton();	
			super.drawBackground(550, 300);
			super.title = 'Global Settings';
			super.defaultButton = _okBtn;
			_okBtn.x = 491;
			_okBtn.y = 265;			
			addChild(_okBtn);
			
			_form.labelWidth = 90;
			_form.fields = [{label:'Name'}, {label:'Email'}, {label:'License Key', enabled:false}];
			_form.y = 70; 
			addChild(_form);
			
			attachOptions();
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
		}

		private function attachOptions():void
		{
			for (var i:int = 0; i < 3; i++) {
				var k:ModalCheckbox = new ModalCheckbox(true);
				k.label = _labels[i];
				k.addEventListener(MouseEvent.CLICK, onCheckboxSelection);
				k.y = 200 + (20 * i);
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
			_checks[2].selected = AppSettings.getSetting(AppSettings.START_AT_LOGIN);
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
					AppSettings.setSetting(AppSettings.START_AT_LOGIN, _checks[2].selected);	
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
