package view.modals.upload {

	import view.modals.base.ModalWindowBasic;
	import view.modals.login.AccountLogin;

	public class LoginToAccount extends ModalWindowBasic {

		private static var _login		:AccountLogin;

		public function set service(s:String):void
		{
			if (_login) removeChild(_login);
			_login = new AccountLogin(s);
			_login.y = 70;
			_login.heading = 'Please login to your '+s+' account';	
			addChild(_login);
		}
		
	}
	
}
