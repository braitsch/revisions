package view.windows.modals.local {

	import events.UIEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import view.windows.base.ParentWindow;

	public class WelcomeScreen extends ParentWindow {

		private static var _btn :Sprite = new Sprite();

		public function WelcomeScreen()
		{
			_btn.x = 267;
			_btn.y = 210;
			_btn.graphics.beginFill(0xff0000, 0);
			_btn.graphics.drawCircle(0, 0, 30);
			_btn.graphics.endFill();
			_btn.buttonMode = true;
			_btn.addEventListener(MouseEvent.CLICK, onClick);
			super.drawBackground(550, 300);
			addChild(new Bitmap(new WelcomePNG()));
			addChild(_btn);
		}

		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_BOOKMARK));
		}
		
	}
	
}
