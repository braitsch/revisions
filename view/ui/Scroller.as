package view.ui {

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Scroller extends Sprite {

		private var _dark		:Shape = new Shape();
		private var _handle		:Sprite = new Sprite();
		private var _view		:Bitmap = new Bitmap(new SliderBkgd());

		public function Scroller()
		{
			addChild(_dark);
			addChild(_view);
			addChild(_handle);
		}
		
		public function draw(h:uint):void
		{
			_dark.graphics.clear();
			_dark.graphics.beginFill(0x6d6e73);
			_dark.graphics.drawRect(0, 0, 5, h);
			_dark.graphics.endFill();
		}
		
	}
	
}
