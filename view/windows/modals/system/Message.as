package view.windows.modals.system {


	public class Message extends Alert {

		private var _view:AlertMC = new AlertMC();

		public function Message(m:String)
		{
			addChild(_view);
			super.title = 'Achtung!';
			super.drawBackground(550, 210);			
			addOkButton();
			_view.textArea.message_txt.htmlText = m;
		}
		
	}
	
}
