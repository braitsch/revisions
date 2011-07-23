package view.modals {

	import events.UIEvent;
	import events.AppEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.remote.RemoteAccount;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;


	public class LoginScreen extends ModalWindow {

		private static var _view			:WindowLoginMC = new WindowLoginMC();
		private static var _accountType		:String;

		public function LoginScreen()
		{
			addChild(_view);
			super.addCloseButton();			
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.pass_txt]));
			super.addButtons([_view.skip_btn, _view.login_btn, _view.github, _view.beanstalk]);
			_view.pass_txt.displayAsPassword = true;
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);
			_view.github.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
		}

		public function set accountType(s:String):void
		{
			_accountType = s;
			_view.name_txt.text = _view.pass_txt.text = '';
			_view.beanstalk.visible = _view.github.visible = false;
			switch(_accountType){
				case RemoteAccount.GITHUB :	
					_view.github.visible = true;		
					setTextFields('Github');
					addBadge(new GitLoginBadge());
				break;
				case RemoteAccount.BEANSTALK :	
					_view.beanstalk.visible = true;
					setTextFields('Beanstalk');
					addBadge(new BeanstalkLoginBadge());
				break;				
			}
		}

		private function addBadge(bmd:BitmapData):void
		{
			var b:Bitmap = new Bitmap(bmd);
				b.x = 16;
			_view.addChild(b);			
		}
		
		private function setTextFields(s:String):void
		{
			_view.sign_up_txt.text = "Don't yet have a "+s+" account?";
			_view.title_txt.text = 'Have a '+s+' account? Please login. (Required for private repositories)';			
		}
		
		private function gotoNewAccountPage(e:MouseEvent):void
		{
			if (_accountType == RemoteAccount.GITHUB){
				navigateToURL(new URLRequest('https://github.com/signup'));
			}	else if (_accountType == RemoteAccount.BEANSTALK){
				navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));
			}
		}		
		
		override public function onEnterKey():void { onLoginButton(); }
		private function onLoginButton(e:MouseEvent = null):void
		{
			if (!validate()) return;
			lockScreen();
			if (_accountType == RemoteAccount.GITHUB){
				AppModel.proxies.github.login(_view.name_txt.text, _view.pass_txt.text);	
			}	else if (_accountType == RemoteAccount.BEANSTALK){
				trace('attempting beanstalk login');
			}			
		}
		
		private function validate():Boolean
		{
			if (_view.name_txt.text && _view.pass_txt.text){
				return true;
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
				return false;
			}
		}		
		
		private function lockScreen():void
		{
			enableButton(_view.skip_btn, false);
			enableButton(_view.login_btn, false);
			AppModel.proxies.github.addEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.github.addEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.proxies.github.addEventListener(AppEvent.GITHUB_READY, onLoginSuccess);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Attemping Login'));
		}
		
		private function unlockScreen():void
		{
			enableButton(_view.skip_btn, true);
			enableButton(_view.login_btn, true);
			AppModel.proxies.github.removeEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.github.removeEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.proxies.github.removeEventListener(AppEvent.GITHUB_READY, onLoginSuccess);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));						
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			unlockScreen();
			dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
		}

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
		//TODO show user window to checkout anonymous github repo over ssh //	
			trace("WindowLogin.onSkipButton(e)");
		}
		
	}
	
}
