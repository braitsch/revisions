package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.modals.ModalWindow;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class LoginScreen extends ModalWindow {

		private var _view:LoginMC = new LoginMC();

		public function LoginScreen()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 240);
			super.addButtons([_view.skip_btn, _view.login_btn, _view.github, _view.beanstalk]);
			setupTextFields();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_view.form.label1.text = 'Username';
			_view.form.label2.text = 'Password';
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);	
		}

		protected function get view():LoginMC { return _view; }
		
		protected function set allowSkip(b:Boolean):void
		{	
			_view.skip_btn.visible = b;
		}

		protected function addBadge(bmd:BitmapData):void
		{
			var b:Bitmap = new Bitmap(bmd);
				b.x = 16;
			_view.addChild(b);			
		}
		
		protected function setTextFields(s:String):void
		{
			_view.sign_up_txt.text = "Don't yet have a "+s+" account?";
			_view.heading.label_txt.text = 'Have a '+s+' account? Please login. (Required for private repositories)';			
		}
		
		protected function onLoginButton(e:MouseEvent = null):void { }
		override public function onEnterKey():void { if (super.locked == false) onLoginButton(); }
		
		protected function validate():Boolean
		{
			if (_view.name_txt.text && _view.pass_txt.text){
				return true;
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Neither field can be blank.'));
				return false;
			}
		}		
		
		protected function lockScreen():void
		{
			super.locked = true;
			enableButton(_view.skip_btn, false);
			enableButton(_view.login_btn, false);
			_view.skip_btn.removeEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.removeEventListener(MouseEvent.CLICK, onLoginButton);			
			AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.proxies.githubApi.addEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.githubApi.addEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Attemping Login'));			
		}
		
		protected function unlockScreen():void
		{
			super.locked = false;
			enableButton(_view.skip_btn, true);
			enableButton(_view.login_btn, true);
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);				
			AppModel.engine.removeEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.proxies.githubApi.removeEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.githubApi.removeEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
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
		
		private function setupTextFields():void
		{
			_view.pass_txt.displayAsPassword = true;
			_view.name_txt.text = _view.pass_txt.text = '';
			_view.beanstalk.visible = _view.github.visible = false;
			_view.pass_txt.tabIndex = 2;
			_view.pass_txt.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_view.name_txt.getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			InteractiveObject(_view.name_txt.getChildAt(1)).tabIndex = 1;
		}

		private function onSkipButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ANONYMOUS_CLONE));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			unlockScreen();
			resize(stage.stageWidth, stage.stageHeight);
			_view.name_txt.setSelection(0, _view.name_txt.length);
			_view.name_txt.textFlow.interactionManager.setFocus();
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (!this.stage) return;
			if (e.keyCode == 13){
				onEnterKey();
			}	else if (e.keyCode == 9){
				if (stage.focus == _view.pass_txt) _view.name_txt.setSelection(0, _view.name_txt.length);
			}
		}	
		
	}
	
}
