package view {

	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Header extends Sprite {
		
		private static var _view:Bitmap = new Bitmap(new HeaderMC());
		
		public function Header()
		{
			addChild(_view);
			// add listeners for buttons 
		}
		
		public function resize():void
		{
			// handle resize event //
		}
		
	}
}
