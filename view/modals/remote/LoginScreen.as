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

		private var _view				:WindowLoginMC = new WindowLoginMC();
		private var _onSuccessEvent		:String;

		public function LoginScreen()
		{
			addChild(_view);
			super.addCloseButton();			
			super.addButtons([_view.skip_btn, _view.login_btn, _view.github, _view.beanstalk]);
			_view.pass_txt.displayAsPassword = true;
			_view.name_txt.text = _view.pass_txt.text = '';
			InteractiveObject(_view.name_txt.getChildAt(1)).tabIndex = 1;
			_view.pass_txt.tabIndex = 2;
			_view.beanstalk.visible = _view.github.visible = false;
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function get view():WindowLoginMC { return _view; }
		
	// the event to dispatch on login success //
		public function set onSuccessEvent(e:String):void 
		{ 
			_onSuccessEvent = e;
			_view.skip_btn.visible = (e != UIEvent.ADD_BKMK_TO_GH);
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
			_view.title_txt.text = 'Have a '+s+' account? Please login. (Required for private repositories)';			
		}
		
		protected function onLoginButton(e:MouseEvent = null):void { }
		override public function onEnterKey():void { onLoginButton(); }
		
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
			enableButton(_view.skip_btn, false);
			enableButton(_view.login_btn, false);
			AppModel.proxies.githubApi.addEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.githubApi.addEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Attemping Login'));
		}
		
		private function unlockScreen():void
		{
			enableButton(_view.skip_btn, true);
			enableButton(_view.login_btn, true);
			AppModel.proxies.githubApi.removeEventListener(AppEvent.OFFLINE, onOffline);
			AppModel.proxies.githubApi.removeEventListener(AppEvent.LOGIN_FAILED, onLoginFailed);
			AppModel.engine.removeEventListener(AppEvent.REMOTE_READY, onLoginSuccess);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));						
		}
		
		private function onLoginSuccess(e:AppEvent):void
		{
			unlockScreen();
			dispatchEvent(new UIEvent(_onSuccessEvent));
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
			dispatchEvent(new UIEvent(UIEvent.ANONYMOUS_CLONE));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			resize(stage.stageWidth, stage.stageHeight);
			_view.name_txt.setSelection(0, _view.name_txt.length);
			_view.name_txt.textFlow.interactionManager.setFocus();
		}	
		
		private function onKeyUp(e:KeyboardEvent):void
		{
	// listen for tab key between the two different types of textfields //	
			if (this.stage && e.keyCode == 9){
				if (stage.focus == _view.pass_txt) _view.name_txt.setSelection(0, _view.name_txt.length);
			}
		}			
		
	}
	
}
