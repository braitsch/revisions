package view.modals.upload {

	import model.remote.HostingAccount;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;

	public class LoginToAccount extends ModalWindowBasic {

		private static var _form		:Sprite;
		private static var _view		:LoginToAccountMC = new LoginToAccountMC();

		public function LoginToAccount()
		{
			addChild(_view);
		}

		public function set service(s:String):void
		{
			if (_form) removeChild(_form);
			if (s == HostingAccount.GITHUB){
				_form = new Form2();
			}	else if (s == HostingAccount.BEANSTALK){
				_form = new Form3(); 
			}
			_form.y = 90;
			addChild(_form);
			super.setHeading(_view, 'Please login to your '+s+' account');	
		}
		
	}
	
}
