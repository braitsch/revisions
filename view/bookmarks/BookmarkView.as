package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.AirContextMenu;
	import view.ui.Scroller;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkView extends Sprite {
		
		private static var _hitArea		:Shape = new Shape(); // for mousewheel scrolling //		
		private static var _header		:Sprite = new Sprite();		
		private static var _list		:BookmarkList = new BookmarkList();
		private static var _bkgd		:Shape = new Shape();
		private static var _scroller	:Scroller = new Scroller();		

		public function BookmarkView()
		{
			addChild(_bkgd);
			addChild(_header);
			addChild(_list);
			addChild(_scroller);
			addChild(_hitArea);
			addHeader();
			
			_scroller.x = 200;
			_hitArea.y = _list.y = _bkgd.y = 33;
			_list.mask = _hitArea;
			_list.contextMenu = AirContextMenu.menu;
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
			_hitArea.graphics.clear();
			_hitArea.graphics.beginFill(0xff0000, 0);
			_hitArea.graphics.drawRect(0, 0, 200, h-33);
			_hitArea.graphics.endFill();						
			_scroller.draw(h);
			if (_hitArea.height > _list.height){
				_list.y = 33;
			}	else{
				var d:Number = _list.height - _hitArea.height;
				var k:Number = d + _list.y - 33;
				if (k < 0) _list.y -= k;
			}
		}

		private function onBookmarkList(e:BookmarkEvent):void 
		{
			var v:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			for (var i:int = 0; i < v.length; i++) _list.addItem(v[i]);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);			
		}

		private function onBookmarkAdded(e:BookmarkEvent):void 
		{
			_list.addItem(e.data as Bookmark);
		}
		
		private function onBookmarkDeleted(e:BookmarkEvent):void 
		{
			_list.removeItem(e.data as Bookmark);
		}
		
		private function onBookmarkSelected(e:BookmarkEvent):void 
		{
			_list.setActiveBookmark(e.data as Bookmark);
		}	
		
		private function onMouseWheel(e:MouseEvent):void
		{
			if (_list.height <= _hitArea.height) return;
			_list.y += e.delta;
			var minY:int = 33 - _list.height + _hitArea.height;
			if (_list.y >= 33) {
				_list.y = 33;
			}	else if (_list.y < minY){
				_list.y = minY;
			}
		}			
		
	}
	
}
