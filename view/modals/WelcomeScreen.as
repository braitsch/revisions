package view.modals {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class WelcomeScreen extends ModalWindow {

		private static var _btn:Sprite = new Sprite();

		public function WelcomeScreen()
		{
			_btn.x = 291;
			_btn.y = 263;
			_btn.graphics.beginFill(0xff0000, 0);
			_btn.graphics.drawCircle(0, 0, 30);
			_btn.graphics.endFill();
			_btn.buttonMode = true;
			_btn.addEventListener(MouseEvent.CLICK, onClick);
			addChild(new Bitmap(new WelcomeMC()));
			addChild(_btn);
		}

		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_BOOKMARK));
		}
		
	}
	
}
