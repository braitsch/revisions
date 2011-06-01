package view {

	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Header extends Sprite {
		
		private static var _appLogo :Bitmap = new Bitmap(new AppLogo());
		private static var _right	:Bitmap = new Bitmap(new HeaderRight());
		private static var _slices	:Sprite = new Sprite();
		
		public function Header()
		{
			_appLogo.y = 12;
			addChild(_slices);
			addChild(_right);
			addChild(_appLogo);
		}
		
		public function resize(w:uint):void
		{
			_slices.graphics.clear();
			_slices.graphics.beginBitmapFill(new HeaderSlice());
			_slices.graphics.drawRect(_right.width-w, 0, w-_right.width, 83);
			_slices.graphics.endFill();
			_appLogo.x = w/2 - _appLogo.width/2;
			_right.x = _slices.x = w-_right.width;
		}
		
	}
	
}
