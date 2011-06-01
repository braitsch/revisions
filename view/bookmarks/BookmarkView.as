package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import view.Scroller;
	import view.layout.ListItem;
	import view.ui.AirContextMenu;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class BookmarkView extends Sprite {
		
		private static var _header		:Sprite = new Sprite();		
		private static var _list		:BookmarkList = new BookmarkList();
		private static var _bkgd		:Shape = new Shape();
		private static var _scroller	:Scroller = new Scroller();		

		public function BookmarkView()
		{
			_bkgd.y = 34;
			_list.y = 34;
			_scroller.x = 200;
			addChild(_bkgd);
			addChild(_header);
			addChild(_list);
			addChild(_scroller);
			
			_list.scrollbar.x = 188;
			_list.setSize(200, 450);
			_list.contextMenu = AirContextMenu.menu;
			addHeader();
						AppModel.engine.addEventListener(BookmarkEvent.LOADED, onBookmarkList);
			AppModel.engine.addEventListener(BookmarkEvent.ADDED, onBookmarkAdded);
			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onBookmarkDeleted);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
		}

		private function addHeader():void
		{
			var text:Bitmap = new Bitmap(new labelBookmarks());
				text.y = 13;
				text.x = 65;
			var bkgd:Shape = new Shape();
				bkgd.graphics.beginBitmapFill(new DkGreyPattern());
				bkgd.graphics.drawRect(0, 0, 200, 32);
				bkgd.graphics.endFill();
			var line:Shape = new Shape();
				line.y = 32;
				line.graphics.clear();
				line.graphics.beginFill(0x000000);
				line.graphics.drawRect(0, 0, 200, 1);
				line.graphics.beginFill(0xb3b3b3);
				line.graphics.drawRect(0, 1, 200, 1);
				line.graphics.endFill();	
			_header.addChild(bkgd);
			_header.addChild(text);
			_header.addChild(line);
		}
		
		public function resize(h:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginBitmapFill(new BookmarkBkgd());
			_bkgd.graphics.drawRect(0, 0, 200, h);
			_bkgd.graphics.endFill();
			_scroller.draw(h);			
		}

		private function onBookmarkList(e:BookmarkEvent):void 
		{
			var v:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			var a:Vector.<ListItem> = new Vector.<ListItem>();
			for (var i:int = 0; i < v.length; i++) a.push(new BookmarkListItem(v[i]));
			_list.build(a);
		}

		private function onBookmarkAdded(e:BookmarkEvent):void 
		{
			_list.addItem(new BookmarkListItem(e.data as Bookmark));
		}
		
		private function onBookmarkDeleted(e:BookmarkEvent):void 
		{
			_list.removeItem(new BookmarkListItem(e.data as Bookmark));
		}
		
		private function onBookmarkSelected(e:BookmarkEvent):void 
		{
			_list.setActiveBookmark(e.data as Bookmark);
		}		
		
	}
	
}
