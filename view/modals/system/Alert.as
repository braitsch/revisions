package view.modals.system {

	import events.AppEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.modals.ModalWindow;

	public class Alert extends ModalWindow {

		private static var _view:WindowAlertMC = new WindowAlertMC();

		public function Alert()
		{
			addChild(_view);
			super.drawBackground(500, 196);
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}

		public function set message(m:String):void
		{
			_view.message_txt.htmlText = m;	
		}
		
		override public function onEnterKey():void { onOkButton(); }		
		private function onOkButton(e:MouseEvent = null):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}
		
	}
	
}
