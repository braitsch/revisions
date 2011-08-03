package view.modals.system {

	import events.AppEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.modals.ModalWindow;

	public class Confirm extends ModalWindow {

		private static var _view:ConfirmMC = new ConfirmMC();

		public function Confirm()
		{
			addChild(_view);
			_view.pageBadge.label_txt.text = 'Confirm';
			super.drawBackground(500, 196);
			super.addButtons([_view.cancel_btn, _view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancelButton);
		}

		public function set message(m:String):void
		{
			_view.message_txt.htmlText = m;	
		}
		
		private function onOkButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_CONFIRM, true));
		}
		
		private function onCancelButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_CONFIRM, false));			
		}		
		
	}
	
}
