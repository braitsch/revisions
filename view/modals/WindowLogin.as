package view.modals {

	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import fl.text.TLFTextField;
	import model.remote.RemoteAccount;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;


	public class WindowLogin extends ModalWindow {

		private static var _view	:WindowLoginMC = new WindowLoginMC();
		private static var _account	:RemoteAccount;

		public function WindowLogin()
		{
			addChild(_view);
			_view.pass_txt.displayAsPassword = true;
			_view.github.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, gotoNewAccountPage);						
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);						
			_view.login_btn.addEventListener(MouseEvent.CLICK, onLoginButton);						
			super.addButtons([_view.skip_btn, _view.login_btn, _view.github, _view.beanstalk]);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt, _view.pass_txt]));
		}

		public function set account(a:RemoteAccount):void
		{
			_account = a;
			_view.name_txt.text = _view.pass_txt.text = '';
			_view.beanstalk.visible = _view.github.visible = false;
			switch(a.type){
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
			if (_account.type == RemoteAccount.GITHUB){
				navigateToURL(new URLRequest('https://github.com/signup'));
			}	else if (_account.type == RemoteAccount.BEANSTALK){
				navigateToURL(new URLRequest('http://beanstalkapp.com/pricing'));
			}
		}		
		
		private function onLoginButton(e:MouseEvent):void
		{
			trace("WindowLogin.onLoginButton(e)", _view.name_txt.text, _view.pass_txt.text);
			if (_account.type == RemoteAccount.GITHUB){
				trace('attempting github login');
			}	else if (_account.type == RemoteAccount.BEANSTALK){
				trace('attempting beanstalk login');
			}			
		}		

		private function onSkipButton(e:MouseEvent):void
		{
			trace("WindowLogin.onSkipButton(e)");
		}
		
	}
	
}
