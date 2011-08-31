package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.modals.base.ModalWindowForm;
	import view.ui.ModalCheckbox;

	public class AccountLogin extends ModalWindowForm {

		private var _view			:*;
		private var _check			:ModalCheckbox;
		private var _onSuccessEvent	:String;

		public function AccountLogin(v:*)
		{
			_view = v;
			super(_view);
			super.addCloseButton();
			super.defaultButton = _view.login_btn;
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);
			_check = new ModalCheckbox(_view.check, true);
			_check.label = 'Remember my login for this account';
			_view.sign_up.buttonMode = true;
			_view.sign_up.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
			AppModel.engine.addEventListener(AppEvent.FAILURE, onLoginFailure);
		}

		public function get saveAccount():Boolean { return _check.selected; }
		
		public function set onSuccessEvent(s:String):void { _onSuccessEvent = s; }
		
		protected function gotoNewAccountPage(e:MouseEvent):void { }
		
		override public function onEnterKey():void { if (super.locked == false) onLoginButton(); }
		protected function onLoginButton(e:MouseEvent = null):void { }
		
		protected function lockScreen():void
		{
			super.locked = true;
			enableButton(_view.login_btn, false);
			_view.login_btn.removeEventListener(MouseEvent.CLICK, onLoginButton);			
		}
		
		override protected function unlockScreen():void
		{
			super.locked = false;
			enableButton(_view.login_btn, true);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);
		}
		
		protected function dispatchLoginSuccessEvent():void 
		{ 
			unlockScreen(); 
			dispatchEvent(new UIEvent(_onSuccessEvent));		
		}		
		
		private function onLoginFailure(e:AppEvent):void
		{
			unlockScreen();
		}

	}
	
}
