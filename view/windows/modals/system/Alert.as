package view.windows.modals.system {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.windows.base.ParentWindow;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Alert extends ParentWindow {

		public function Alert()
		{
			super.addCloseButton();
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
			addEventListener(UIEvent.NO_BUTTON, onNoButton);
		}
		
		protected function onOkButton(e:Event):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}		

		protected function onNoButton(e:UIEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}
		
		override protected function onCloseClick(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_ALERT));
		}		
		
	}
	
}
