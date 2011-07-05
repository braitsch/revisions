package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.proxies.ConfigProxy;
	import mx.utils.StringUtil;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NameAndEmail extends ModalWindow {

		private static var _view	:NameAndEmailMC = new NameAndEmailMC();
		private static var _config	:ConfigProxy = AppModel.proxies.config;

		public function NameAndEmail()
		{
			addChild(_view);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.email_txt]));			
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}
		
		private function onGitSettings(e:InstallEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			_config.removeEventListener(InstallEvent.GIT_SETTINGS, onGitSettings);
		}

		private function onAddedToStage(e:Event):void
		{
			_view.name_txt.text = _config.userName;
			_view.email_txt.text = _config.userEmail;
			_config.addEventListener(InstallEvent.GIT_SETTINGS, onGitSettings);
		}

		private function onOkButton(evt:MouseEvent):void
		{
			var n:String = StringUtil.trim(_view.name_txt.text);
			var e:String = StringUtil.trim(_view.email_txt.text);
			var m:String = NameAndEmail.validate(n, e);
			if (m == ''){
				_config.setUserNameAndEmail(n, e);
			}	else{
				AppModel.engine.dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
			}
		}
		
		public static function validate(n:String, e:String):String
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
