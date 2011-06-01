package view.bookmarks {

	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Bookmarks extends Sprite {

		private static var _view:Bitmap = new Bitmap(new BookmarkMC());

		public function Bookmarks()
		{
			addChild(_view);
		}
		
	}
	
}
