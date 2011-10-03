package view.bookmarks {

	import system.AirContextMenu;
	import view.type.ColumnHeading;
	import view.ui.Scroller;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class BookmarkView extends Sprite {
		
		private static var _header		:Sprite = new Sprite();		
		private static var _list		:BookmarkList = new BookmarkList();
		private static var _bkgd		:Shape = new Shape();
		private static var _scroller	:Scroller = new Scroller();	

		public function BookmarkView()
		{
			_scroller.x = 200;
			_list.y = _bkgd.y = 33;
			_list.contextMenu = AirContextMenu.menu;
			
			addChild(_bkgd);
			addChild(_header);
			addChild(_list);
			addChild(_scroller);
			addHeader();
		}
		
		public function resize(h:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginBitmapFill(new BookmarkBkgd());
			_bkgd.graphics.drawRect(0, 0, 200, h - this.y - _bkgd.y);
			_bkgd.graphics.endFill();
			_scroller.draw(h - this.y);
			_list.resize(h - this.y - _bkgd.y);
		}		

		private function addHeader():void
		{
			var text:ColumnHeading = new ColumnHeading();
				text.text = 'Bookmarks';
				text.y = 13;
				text.x = 60;
			var bkgd:Shape = new Shape();
				bkgd.graphics.beginBitmapFill(new DkGreyPattern());
				bkgd.graphics.drawRect(0, 0, 200, 32);
				bkgd.graphics.endFill();
			var line:Shape = new Shape();
				line.y = 32;
				line.graphics.clear();
				line.graphics.beginFill(0x000000);
				line.graphics.drawRect(0, 0, 200, 1);
				line.graphics.endFill();	
			_header.addChild(bkgd);
			_header.addChild(text);
			_header.addChild(line);
		}
		
	}
	
}
