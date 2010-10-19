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
			
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady, false, 1);
		}

		private function onBookmarksReady(e:RepositoryEvent):void 
		{
			var v:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			var a:Vector.<ListItem> = new Vector.<ListItem>();
			
			for (var i:int = 0; i < v.length; i++) a.push(new BookmarkItem(v[i]));
			_list.refresh(a);
			
			dispatchEvent(new UICommand(UICommand.BOOKMARK_SELECTED, _list.activeItem));
		}
		
		private function onListSelection(e:UICommand):void 
		{			dispatchEvent(new UICommand(UICommand.BOOKMARK_SELECTED, _list.activeItem));
		}	

	}
	
}
