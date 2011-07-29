package view.modals.git {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.proxies.ConfigProxy;
	import mx.utils.StringUtil;
	import view.modals.ModalWindow;

	public class NameAndEmail extends ModalWindow {

		private static var _view	:NameAndEmailMC = new NameAndEmailMC();
		private static var _config	:ConfigProxy = AppModel.proxies.config;

		public function NameAndEmail()
		{
			addChild(_view);
			super.drawBackground(500, 225);
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.email_txt]));
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}
		
		private function onGitSettings(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			_config.removeEventListener(AppEvent.GIT_SETTINGS, onGitSettings);
		}

		private function onAddedToStage(e:Event):void
		{
			_view.name_txt.text = _config.userName;
			_view.email_txt.text = _config.userEmail;
			_config.addEventListener(AppEvent.GIT_SETTINGS, onGitSettings);
		}

		override public function onEnterKey():void { onOkButton(); }
		private function onOkButton(evt:MouseEvent = null):void
		{
			var n:String = StringUtil.trim(_view.name_txt.text);
			var e:String = StringUtil.trim(_view.email_txt.text);
			var m:String = NameAndEmail.validate(n, e);
			if (m == ''){
				_config.setUserNameAndEmail(n, e);
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
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
