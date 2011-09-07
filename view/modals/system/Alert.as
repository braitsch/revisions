package view.modals.system {

	import events.AppEvent;
	import model.AppModel;
	import view.modals.base.ModalWindow;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Alert extends ModalWindow {

		private var _okButton	:Sprite;
		private var _noButton	:Sprite;

		public function Alert()
		{
			super.addCloseButton();
		}

		public function set okButton(btn:Sprite):void
		{
			_okButton = btn;
			_okButton.addEventListener(MouseEvent.CLICK, onOkButton);
			super.defaultButton = _okButton;
		}

		public function set noButton(btn:Sprite):void
		{
			_noButton = btn;
			_noButton.addEventListener(MouseEvent.CLICK, onNoButton);
			super.addButtons([_noButton]);
		}
		
		protected function onOkButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}		

		protected function onNoButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}
		
		override protected function onCloseClick(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}		
		
	}
	
}
