package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.Account;
	import model.remote.HostingProvider;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class AccountLogin extends BaseNameAndPass {

		private static var _host			:HostingProvider;
		private static var _view			:AccountLoginMC = new AccountLoginMC();
		private static var _onSuccessEvent	:String;

		public function AccountLogin()
		{
			super(_view);
			super.addCloseButton();
			super.drawBackground(550, 240);
			super.defaultButton = _view.login_btn;
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);
		}
		
		public function set host(o:HostingProvider):void
		{
			_host = o;
			setTextFields();
			setAccountBtn();
			setTitle(_view, o.loginObj.title);
		}
		
		public function set onSuccessEvent(s:String):void
		{
			_onSuccessEvent = s;
		}

		private function setAccountBtn():void
		{
			var btn:Sprite = _host.loginObj.button;
			_view.addChild(btn);
			super.addButtons([btn]);
			btn.x = 36; btn.y = 198;
			btn.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
		}

		private function setTextFields():void
		{
			_view.name_txt.text = 'braitsch'; _view.pass_txt.text = 'aelisch76';
			_view.sign_up_txt.text = "Don't yet have a "+_host.type+" account?";
			super.setHeading(_view, 'Have a '+_host.type+' account? Please login. (Required for private repositories)');
		}
		
		private function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest(_host.loginObj.signup));
		}
		
		override public function onEnterKey():void { if (super.locked == false) onLoginButton(); }
		private function onLoginButton(e:MouseEvent = null):void 
		{ 
			if (validate()){
				lockScreen();
				_host.proxy.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
				_host.proxy.addEventListener(AppEvent.LOGIN_FAILURE, onLoginFailure);
				_host.proxy.login(new Account({type:_host.type, user:super.name, pass:super.pass}));
				_host.proxy.login(new Account({type:_host.type, user:super.name, pass:super.pass}));
			}
		}
		
		private function lockScreen():void
		{
			super.locked = true;
			enableButton(_view.login_btn, false);
			_view.login_btn.removeEventListener(MouseEvent.CLICK, onLoginButton);			
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Attemping Login'}));
		}
		
		override protected function unlockScreen():void
		{
			super.locked = false;
			enableButton(_view.login_btn, true);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}
		
		private function onLoginSuccess(e:AppEvent):void 
		{ 
			unlockScreen(); 
			_host.home.model = e.data as Account;
			_host.proxy.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			_host.proxy.removeEventListener(AppEvent.LOGIN_FAILURE, onLoginFailure);
			dispatchEvent(new UIEvent(_onSuccessEvent));
		}

		private function onLoginFailure(e:AppEvent):void 
		{ 
			unlockScreen(); 
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.FAILURE, e.data));
		}
		
	}
	
}
