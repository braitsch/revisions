package view.windows.modals.system {

	import events.UIEvent;
	import flash.events.Event;

	public class Confirm extends Alert {

		private var _view	:ConfirmMC = new ConfirmMC();

		public function Confirm(m:String = '')
		{
			addChild(_view);
			super.drawBackground(550, 240);
			super.title = 'Confirm';
			addOkButton();
			addNoButton();
			_view.textArea.message_txt.htmlText = m;
		}
		
		public function set message(m:String):void
		{
			_view.textArea.message_txt.htmlText = m;	
		}

		override protected function onOkButton(e:Event):void
		{
			super.onOkButton(e);
			dispatchEvent(new UIEvent(UIEvent.CONFIRM, true));
		}
		
		override protected function onNoButton(e:UIEvent):void
		{
			super.onNoButton(e);
			dispatchEvent(new UIEvent(UIEvent.CONFIRM, false));
		}		

	}
	
}
