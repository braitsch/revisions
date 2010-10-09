package view.bookmarks {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;

	import view.layout.LiquidColumn;
	import view.layout.SimpleList;
	import view.ui.AirContextMenu;

	public class BookmarkView extends LiquidColumn {
		
		private static var _list			:SimpleList = new SimpleList();
		private static var _view			:BookmarkViewMC = new BookmarkViewMC();

		public function BookmarkView()
		{
			super.width = 200;
			super.list = _list;
			
			_view.addChild(_list);
			addChild(_view);
			
			_list.x = 5;
			_list.y = 38;	
			_list.contextMenu = AirContextMenu.menu;
			_list.addEventListener(UICommand.LIST_ITEM_SELECTED, onListSelection);
			
			AppModel.branch.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady);
		}

		private function onBookmarksReady(e:RepositoryEvent):void 
		{
			super.redrawList(AppModel.bookmarks);
		}
		
		private function onListSelection(e:UICommand):void 
		{
			AppModel.bookmark = _list.activeItem as Bookmark;
		}	

	}
	
}
