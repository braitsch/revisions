package view.modals {

	import mx.utils.StringUtil;
	import model.proxies.ConfigProxy;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
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
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}

		private function onGitSettings(e:InstallEvent):void
		{
			if (!_config.userName || !_config.userEmail){
				setUserNameAndEmail();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				_config.dispatchEvent(new InstallEvent(InstallEvent.GIT_IS_READY));
				_config.removeEventListener(InstallEvent.GIT_SETTINGS, onGitSettings);				
			}
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
				setUserNameAndEmail();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
			}
		}
		
		private function setUserNameAndEmail():void
		{
			if (!_config.userName){
				_config.userName = StringUtil.trim(_view.name_txt.text);
			}	else if (!_config.userEmail) {
				_config.userEmail = StringUtil.trim(_view.email_txt.text);
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
