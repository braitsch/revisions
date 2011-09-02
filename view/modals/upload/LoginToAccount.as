package view.modals.upload {

	import view.modals.base.ModalWindowBasic;

	public class LoginToAccount extends ModalWindowBasic {

		private static var _service	:String;
		private static var _view	:LoginToAccountMC = new LoginToAccountMC();

		public function LoginToAccount()
		{
			addChild(_view);
		}

		public function set service(s:String):void
		{
			_service = s;
			super.setHeading(_view, 'Please login to your '+_service+' account');	
		}
		
	}
	
}
