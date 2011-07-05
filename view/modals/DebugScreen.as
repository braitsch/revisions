package view.modals {

	import events.AppEvent;
	import model.AppModel;
	import flash.events.MouseEvent;

	public class DebugScreen extends ModalWindow {

		private static var _view:WindowDebugMC = new WindowDebugMC();

		public function DebugScreen()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOKButton);
		}

		public function set message(o:Object):void
		{
			var m:String = 'Sorry, it looks like there was a problem! \n';
			m+='Source : '+o.s+'\n';
			m+='Method : "'+o.m+'" failed \n';
			m+='Message: '+o.r;			
			_view.message_txt.htmlText = m;
		}
		
		private function onOKButton(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_DEBUG));
		}
		
		override protected function onCloseClick(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_DEBUG));
		}		
		
	}
	
}
