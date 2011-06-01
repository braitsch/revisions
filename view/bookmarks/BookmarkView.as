package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import view.layout.ListItem;
	import view.ui.AirContextMenu;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class BookmarkView extends Sprite {
		
		private static var _list			:BookmarkList = new BookmarkList();
		private static var _view			:Sprite = new Sprite();

		public function BookmarkView()
		{
			_view.addChild(new Bitmap(new BookmarkMC()));
			_view.addChild(_list);
			addChild(_view);
			
			_list.x = 5;
			_list.y = 38;
			_list.scrollbar.x = 188;
			_list.setSize(200, 450);
			_list.contextMenu = AirContextMenu.menu;
			
			AppModel.engine.addEventListener(BookmarkEvent.LOADED, onBookmarkList);			AppModel.engine.addEventListener(BookmarkEvent.ADDED, onBookmarkAdded);
			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onBookmarkDeleted);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
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
