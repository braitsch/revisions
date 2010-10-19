package view.bookmarks {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;

	import view.layout.LiquidColumn;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.ui.AirContextMenu;

	public class BookmarkView extends LiquidColumn {
		
		private static var _list			:SimpleList = new SimpleList();
		private static var _view			:BookmarkViewMC = new BookmarkViewMC();

		public function BookmarkView()
		{
			super.width = 200;
			
			_view.addChild(_list);
			addChild(_view);
			
			_list.x = 5;
			_list.y = 38;
			_list.scrollbar.x = 188;
			_list.setSize(200, 450);
			_list.contextMenu = AirContextMenu.menu;
			_list.addEventListener(UICommand.LIST_ITEM_SELECTED, onListSelection);
			
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkSet);			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_LIST, onBookmarkList);
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_ADDED, onBookmarkAdded);
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_DELETED, onBookmarkDeleted);			
		}

		private function onBookmarkSet(e:RepositoryEvent):void 
		{
			if (e.data == null) return;
			for (var i:int = 0; i < _list.container.numChildren; i++) {
				var k:ListItem = _list.container.getChildAt(i) as ListItem;
				if (k.file == e.data.file) _list.activeItem = k;
			}
		}

		private function onBookmarkList(e:RepositoryEvent):void 
		{
			trace("BookmarkView.onBookmarkList(e)");
			var v:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			var a:Vector.<ListItem> = new Vector.<ListItem>();
			
			for (var i:int = 0; i < v.length; i++) a.push(new BookmarkItem(v[i]));
			_list.refresh(a);
		}

		private function onBookmarkAdded(e:RepositoryEvent):void 
		{
			trace("BookmarkView.onBookmarkAdded(e)");
			_list.addItem(new BookmarkItem(e.data as Bookmark));
		}
		
		private function onBookmarkDeleted(e:RepositoryEvent):void 
		{
			trace("BookmarkView.onBookmarkDeleted(e)");
			_list.removeItem(new BookmarkItem(e.data as Bookmark));
		}
		
		private function onListSelection(e:UICommand):void 		{
			dispatchEvent(new UICommand(UICommand.BOOKMARK_SELECTED, BookmarkItem(_list.activeItem).bookmark));
		}
		
	}
	
}
