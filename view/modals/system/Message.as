package view.modals.system {


	public class Message extends Alert {

		private var _view:AlertMC = new AlertMC();

		public function Message(m:String)
		{
			addChild(_view);
			super.drawBackground(550, 210);			
			super.setTitle(_view, 'Achtung!');
			super.okButton = _view.ok_btn;
			_view.textArea.message_txt.htmlText = m;
		}

	}
	
}
