package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
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
			super.addButtons([_view.skip_btn]);
			super.defaultButton = _view.login_btn;
		//TODO implement non-logged in clones ( ssh & https )	
			_view.skip_btn.visible = false;
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);	
		}

		protected function set allowSkip(b:Boolean):void
		{	
		//	_view.skip_btn.visible = b;
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
			enableButton(_view.skip_btn, false);
			enableButton(_view.login_btn, false);
			_view.skip_btn.removeEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.removeEventListener(MouseEvent.CLICK, onLoginButton);			
			AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.proxies.ghLogin.addEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.ghLogin.addEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Attemping Login'));			
		}
		
		override protected function unlockScreen():void
		{
			super.locked = false;
			enableButton(_view.skip_btn, true);
			enableButton(_view.login_btn, true);
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);				
			AppModel.engine.removeEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.proxies.ghLogin.removeEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.ghLogin.removeEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));					
		}
		
		protected function onLoginSuccess(e:AppEvent):void { }

		private function onLoginFailed(e:AppEvent):void
		{
			unlockScreen();
			var m:String = 'Login Attempt Failed.\nPlease Check Your Credentials.';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}
		
		private function onOffline(e:AppEvent):void
		{
			unlockScreen();
			var m:String = 'Could Not Connect To Remote Server.\nPlease Check Your Internet Connection';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}	
		
		private function onSkipButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ANONYMOUS_CLONE));
		}
		
	}
	
}
