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
		private var _login			:BasicButton = new BasicButton(new LoginButton());
		private var _signUp			:TextLinkMC = new TextLinkMC();

		public function AccountLogin(s:String)
		{
			_type = s;
			_check.label = 'Remember my login for this account';
			
			_login.enabled = true;
			_login.addEventListener(MouseEvent.CLICK, onLoginButton);
			_login.x = 484;
			
			_signUp.buttonMode = true;
			_signUp.x = 10;
			_signUp.grey.autoSize = TextFieldAutoSize.LEFT;
			_signUp.grey.text = 'Don\'t yet have a '+s+' account?';
			_signUp.blue.text = 'Create one for free!';
			_signUp.blue.x = _signUp.grey.x + _signUp.grey.width;
			_signUp.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
			
			if (s == HostingAccount.GITHUB){
				attachGHForm();
			}	else if (s == HostingAccount.BEANSTALK){
				attachBSForm();
			}
			
			_form.y = 20;
			addEventListener(UIEvent.ENTER_KEY, onLoginButton);
			
			addChild(_form); addChild(_check);
			addChild(_signUp);
			_login.addTo(this);
		}
		
		private function attachGHForm():void
		{
			_form = new Form(new Form2());
			_form.labels = ['Username', 'Password'];
			_form.enabled = [1, 2];
			_signUp.y = 100;
		}
		
		private function attachBSForm():void
		{
			_form = new Form(new Form3());
			_form.labels = ['Account', 'Username', 'Password'];
			_form.enabled = [1, 2, 3];
			_signUp.y = 130;		
		}
		
		public function set baseline(y:uint):void
		{
			y = y - this.y - 35;
			_login.y = y; _check.y = y - 10; 
		}
		
		private function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			if (_type == HostingAccount.GITHUB){
				navigateToURL(new URLRequest('https://github.com/signup'));		
			}	else if (_type == HostingAccount.BEANSTALK){
				navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));
			}		
		}
		
		private function onLoginButton(e:Event):void 
		{ 
			if (_login.enabled == false) return;
			if (_form.validate()){
				_login.enabled = false;
				if (_type == HostingAccount.GITHUB){
					attemptGHLogin();			
				}	else if (_type == HostingAccount.BEANSTALK){
					attemptBSLogin();
				}
				AppModel.engine.addEventListener(ErrEvent.LOGIN_FAILURE, onLoginFailure);
			}			
		}

		private function attemptGHLogin():void
		{
			var a:HostingAccount = new HostingAccount({type:HostingAccount.GITHUB, 
					acct:_form.getField(0), user:_form.getField(0), pass:_form.getField(1)});						
			Hosts.github.attemptLogin(a, _check.selected);
			Hosts.github.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}

		private function attemptBSLogin():void
		{
			var a:HostingAccount = new HostingAccount({type:HostingAccount.BEANSTALK, 
					acct:_form.getField(0), user:_form.getField(1), pass:_form.getField(2)});
			Hosts.beanstalk.attemptLogin(a, _check.selected);
			Hosts.beanstalk.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}	
		
		private function onLoginSuccess(e:AppEvent):void
		{
			_login.enabled = true;
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS));
			AppModel.engine.removeEventListener(ErrEvent.LOGIN_FAILURE, onLoginFailure);
		}			
		
		private function onLoginFailure(e:ErrEvent):void
		{
			_login.enabled = true;
			AppModel.engine.removeEventListener(ErrEvent.LOGIN_FAILURE, onLoginFailure);
		}
		
	}
	
}
