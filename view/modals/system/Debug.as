package view.modals.system {

	import events.AppEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.modals.ModalWindow;

	public class Debug extends ModalWindow {

		private static var _view:DebugMC = new DebugMC();

		public function Debug()
		{
			addChild(_view);
			super.drawBackground(500, 400);
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
		}

		public function set message(o:Object):void
		{
			var m:String = 'Sorry, it looks like there was a problem! \n';
			m+='Source : '+o.source+'\n';
			m+='Method : '+o.method+' failed \n';
			m+='Message: '+o.message+'\n' || o.result+'\n';
			if (o.errors) for (var k:String in o.errors[0]) m+='Error: '+k+' -- '+o.errors[0][k]+'\n';		
			_view.message_txt.htmlText = m;
		}
		
		override public function onEnterKey():void { onOkButton(); }		
		private function onOkButton(e:MouseEvent = null):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_DEBUG));
		}
		
		override protected function onCloseClick(e:MouseEvent):void 
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_DEBUG));
		}		
		
	}
	
}
