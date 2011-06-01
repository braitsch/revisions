package view.modals {

	public class UserError extends ModalWindow {

		private static var _view	:UserErrorMC;

		public function UserError()
		{
			_view = new UserErrorMC();
			addChild(_view);
		}

		public function set message(e:String):void
		{
			_view.message_txt.htmlText = e;
		}
		
	}
	
}
