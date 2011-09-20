package view.modals.login {

	import events.AppEvent;
	import events.ErrEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.BasicButton;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;

	public class AccountLogin extends Sprite {

		private var _form			:Form;
		private var _type			:String;
		private var _check			:ModalCheckbox = new ModalCheckbox(true);
		private var _loginBtn		:BasicButton = new BasicButton(new LoginButton());
		private var _signUp			:TextLinkMC = new TextLinkMC();
		private var _signUpURL		:String;

		public function AccountLogin(s:String)
		{
			_type = s;
			_check.label = 'Remember my login for this account';
			
			_loginBtn.enabled = true;
			_loginBtn.addEventListener(MouseEvent.CLICK, onLoginButton);
			_loginBtn.x = 484;
			_loginBtn.addTo(this);
			
			attachSignUp();
			if (_type == HostingAccount.GITHUB){
				attachGHForm();
			}	else if (_type == HostingAccount.BEANSTALK){
				attachBSForm();
			}
			_form.y = 20;
			
			addChild(_form); 
			addChild(_check);
			addChild(_signUp);
			addEventListener(UIEvent.ENTER_KEY, onLoginButton);
			AppModel.engine.addEventListener(ErrEvent.LOGIN_FAILURE, onLoginFailure);
			AppModel.engine.addEventListener(ErrEvent.NO_CONNECTION, onLoginFailure);
			AppModel.engine.addEventListener(ErrEvent.SERVER_FAILURE, onLoginFailure);
		}
		
		private function attachSignUp():void
		{
			_signUp.x = 10;
			_signUp.buttonMode = true;
			_signUp.grey.autoSize = TextFieldAutoSize.LEFT;
			_signUp.grey.text = 'Don\'t yet have a '+_type+' account?';
			_signUp.blue.text = 'Create one for free!';
			_signUp.blue.x = _signUp.grey.x + _signUp.grey.width;
			_signUp.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);			
		}
		
		private function attachGHForm():void
		{
			_form = new Form(new Form2());
			_form.labels = ['Username', 'Password'];
			_form.enabled = [1, 2];
			_signUp.y = 100;
			_signUpURL = 'https://github.com/signup';
		}
		
		private function attachBSForm():void
		{
			_form = new Form(new Form3());
			_form.labels = ['Account', 'Username', 'Password'];
			_form.setField(0, 'braitsch');
			_form.setField(1, 'braitsch');
			_form.setField(2, 'aelisch76');
			_form.enabled = [1, 2, 3];
			_signUp.y = 130;
			_signUpURL = 'http://beanstalkapp.com/pricing';
		}
		
		public function set baseline(y:uint):void
		{
			y = y - this.y - 35;
			_loginBtn.y = y; _check.y = y - 10; 
		}
		
		private function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			navigateToURL(new URLRequest(_signUpURL));
		}
		
		private function onLoginButton(e:Event):void 
		{ 
			if (_loginBtn.enabled == false) return;
			if (_form.validate()){
				_loginBtn.enabled = false;
				if (_type == HostingAccount.GITHUB){
					attemptGHLogin();			
				}	else if (_type == HostingAccount.BEANSTALK){
					attemptBSLogin();
				}
			}
			AppModel.engine.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}

		private function attemptGHLogin():void
		{
			var a:HostingAccount = new HostingAccount({type:HostingAccount.GITHUB, 
				acct:_form.getField(0), user:_form.getField(0), pass:_form.getField(1)});
			Hosts.github.attemptLogin(a, _check.selected);
		}

		private function attemptBSLogin():void
		{
			var a:HostingAccount = new HostingAccount({type:HostingAccount.BEANSTALK, 
				acct:_form.getField(0), user:_form.getField(1), pass:_form.getField(2)});
			Hosts.beanstalk.attemptLogin(a, _check.selected);
		}
		
		protected function onLoginSuccess(e:AppEvent):void
		{
			_loginBtn.enabled = true;
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS));
			AppModel.engine.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}

		private function onLoginFailure(e:ErrEvent):void 
		{
			_loginBtn.enabled = true;
			AppModel.engine.removeEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);			
		}
		
	}
	
}
