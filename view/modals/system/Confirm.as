package view.modals.system {

	import events.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Confirm extends Alert {

		private var _view	:ConfirmMC = new ConfirmMC();

		public function Confirm(m:String)
		{
			addChild(_view);
			super.drawBackground(550, 240);
			super.setTitle(_view, 'Confirm');
			super.noButton = _view.cancel_btn;
			super.defaultButton = _view.ok_btn;
			_view.textArea.message_txt.htmlText = m;
		}

		override protected function onOkButton(e:Event):void
		{
			super.onOkButton(e);
			dispatchEvent(new UIEvent(UIEvent.CONFIRM, true));
		}
		
		override protected function onNoButton(e:MouseEvent):void
		{
			super.onNoButton(e);
			dispatchEvent(new UIEvent(UIEvent.CONFIRM, false));
		}		

	}
	
}
