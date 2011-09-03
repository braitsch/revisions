package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.BasicButton;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;

	public class AccountLogin extends Sprite {

		private var _onSuccessEvent	:String;
		private var _form			:Form;
		private var _type			:String;
		private var _check			:ModalCheckbox = new ModalCheckbox(true);
		private var _login			:BasicButton = new BasicButton(new LoginButton());
		private var _signUp			:AccountSignUp = new AccountSignUp();
		private var _heading		:TextHeading = new TextHeading();

		public function AccountLogin(s:String)
		{
			_type = s;
			_check.label = 'Remember my login for this account';
			
			_login.enabled = true;
			_login.addEventListener(MouseEvent.CLICK, onLoginButton);
			_login.x = 480;
			
			_signUp.buttonMode = true;
			_signUp.x = 10;
			_signUp.grey.autoSize = TextFieldAutoSize.LEFT;
			_signUp.grey.text = 'Don\'t yet have a '+s+' account?';
			_signUp.blue.text = 'Create one for free!';
			_signUp.blue.x = _signUp.grey.x + _signUp.grey.width;
			_signUp.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
			
			if (s == HostingAccount.GITHUB){
				_form = new Form(new Form2());
				_form.labels = ['Username', 'Password'];
				_check.y = 130; _login.y = 140; _signUp.y = 100;
				_form.inputs = [new FINorm().getChildAt(0), new FIPass().getChildAt(0)];
			}	else if (s == HostingAccount.BEANSTALK){
				_form = new Form(new Form3());
				_form.labels = ['Account', 'Username', 'Password'];
				_check.y = 160; _login.y = 170; _signUp.y = 130;
				_form.inputs = [new FINorm().getChildAt(0), new FINorm().getChildAt(0), new FIPass().getChildAt(0)];
			}			
			
			_form.y = 20; _heading.x = 10;
			
			addChild(_form); addChild(_check);
			addChild(_login); addChild(_signUp); addChild(_heading);
			AppModel.engine.addEventListener(AppEvent.FAILURE, onLoginFailure);
		}
		
		public function set heading(s:String):void
		{
			_heading.label_txt.autoSize = TextFieldAutoSize.LEFT;
			_heading.label_txt.htmlText = s;
		}
		
		public function set inputs(v:*):void { _form.inputs = v; }
		public function set onSuccessEvent(s:String):void { _onSuccessEvent = s; }
		
		private function gotoNewAccountPage(e:MouseEvent):void 
		{ 
			if (_type == HostingAccount.GITHUB){
				navigateToURL(new URLRequest('https://github.com/signup'));		
			}	else if (_type == HostingAccount.BEANSTALK){
				navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));
			}		
		}
		
		public function onLoginButton(e:MouseEvent = null):void 
		{ 
			if (_login.enabled == false) return;
			if (_form.validate()){
				_login.enabled = false;
				if (_type == HostingAccount.GITHUB){
					attemptGHLogin();			
				}	else if (_type == HostingAccount.BEANSTALK){
					attemptBSLogin();
				}
			}			
		}

		private function attemptGHLogin():void
		{
			var a:HostingAccount = new HostingAccount({type:_type, 
					acct:_form.fields[0], user:_form.fields[0], pass:_form.fields[1]});						
			Hosts.github.attemptLogin(a, _check.selected);
			Hosts.github.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}

		private function attemptBSLogin():void
		{
			var a:HostingAccount = new HostingAccount({type:HostingAccount.BEANSTALK, 
					acct:_form.fields[0], user:_form.fields[1], pass:_form.fields[2]});
			Hosts.beanstalk.attemptLogin(a, _check.selected);
			Hosts.beanstalk.api.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
		}	
		
		private function onLoginSuccess(e:AppEvent):void
		{
			_login.enabled = true;
			if (_onSuccessEvent) dispatchEvent(new UIEvent(_onSuccessEvent));		
		}			
		
		private function onLoginFailure(e:AppEvent):void
		{
			_login.enabled = true;
		}
		
	}
	
}
