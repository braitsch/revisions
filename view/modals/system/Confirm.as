package view.modals.system {


	public class Confirm extends Alert {

		private var _view	:ConfirmMC = new ConfirmMC();

		public function Confirm(m:String)
		{
			addChild(_view);
			super.drawBackground(550, 210);
			super.setTitle(_view, 'Confirm');
			_view.textArea.message_txt.htmlText = m;
		//	super.addButtons([_view.cancel_btn]);
		//	super.defaultButton = _view.ok_btn;
		}

	}
	
}
