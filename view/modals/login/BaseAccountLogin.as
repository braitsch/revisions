package view.modals.login {

	import events.AppEvent;
	import model.AppModel;
	import flash.events.MouseEvent;

	public class BaseAccountLogin extends BaseNameAndPass {

		private var _view:*;

		public function BaseAccountLogin(v:*)
		{
			_view = v;
			super(_view);
			super.addCloseButton();
			super.drawBackground(550, 240);
			super.defaultButton = _view.login_btn;
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);	
		}

		protected function set accountBtn(btn:*):void
		{
			_view.addChild(btn);
			super.addButtons([btn]);
			btn.x = 36; btn.y = 198;
			btn.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
		}

		protected function setTextFields(s:String):void
		{
			_view.sign_up_txt.text = "Don't yet have a "+s+" account?";
			super.setHeading(_view, 'Have a '+s+' account? Please login. (Required for private repositories)');
		}
		
		protected function gotoNewAccountPage(e:MouseEvent):void { }
		
		protected function onLoginButton(e:MouseEvent = null):void { }
		override public function onEnterKey():void { if (super.locked == false) onLoginButton(); }
		
		protected function lockScreen():void
		{
			super.locked = true;
			enableButton(_view.login_btn, false);
			_view.login_btn.removeEventListener(MouseEvent.CLICK, onLoginButton);			
			AppModel.engine.addEventListener(AppEvent.FAILURE, onLoginFailure);
			AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Attemping Login'}));
		}
		
		override protected function unlockScreen():void
		{
			super.locked = false;
			enableButton(_view.login_btn, true);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);				
			AppModel.engine.removeEventListener(AppEvent.FAILURE, onLoginFailure);
			AppModel.engine.removeEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));					
		}
		
		private function onLoginSuccess(e:AppEvent):void { unlockScreen(); }
		private function onLoginFailure(e:AppEvent):void { unlockScreen(); }
		
	}
	
}
