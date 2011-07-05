package view.modals {

	import events.AppEvent;
	import model.AppModel;
	import flash.events.MouseEvent;

	public class Alert extends ModalWindow {

		private static var _view:WindowAlertMC = new WindowAlertMC();

		public function Alert()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOKButton);
		}

		public function set message(m:String):void
		{
			_view.message_txt.htmlText = m;			
		}
		
		private function onOKButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}
		
		override protected function onCloseClick(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}		
		
	}
	
}
