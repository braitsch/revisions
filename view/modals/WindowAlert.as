package view.modals {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import view.modals.ModalWindow;

	public class WindowAlert extends ModalWindow {

		private static var _view:WindowAlertMC = new WindowAlertMC();

		public function WindowAlert()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOKButton);
		}

		public function set message(m:String):void
		{
			_view.message_txt.text = m;			
		}
		
		private function onOKButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
