package view.windows.modals.system {

	import events.AppEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.windows.base.ParentWindow;

	public class Alert extends ParentWindow {

		private var _okButton	:Sprite;
		private var _noButton	:Sprite;

		public function Alert()
		{
			super.addCloseButton();
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
		}
		
		public function set okButton(btn:Sprite):void
		{
			_okButton = btn;
			super.defaultButton = _okButton;
		}

		public function set noButton(btn:Sprite):void
		{
			_noButton = btn;
			_noButton.addEventListener(MouseEvent.CLICK, onNoButton);
			super.addButtons([_noButton]);
		}
		
		protected function onOkButton(e:Event):void
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
