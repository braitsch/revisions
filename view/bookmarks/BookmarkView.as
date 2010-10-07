package view.bookmarks {
	import events.RepositoryEvent;
	import commands.UICommand;

	import events.DataBaseEvent;

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
			super.list = _list;
			
			_view.addChild(_list);
			addChild(_view);
			
			_list.contextMenu = AirContextMenu.menu;
			_list.addEventListener(UICommand.LIST_ITEM_SELECTED, onListSelection);
			
		// refresh view whenever we get an updated list from the database //	
			AppModel.database.addEventListener(DataBaseEvent.REPOSITORIES, onRepositories);	
		}
		
		private function onListSelection(e:UICommand):void 
		{
			AppModel.bookmark = _list.activeItem as Bookmark;
		}
		
		private function onRepositories(e:DataBaseEvent):void 
		{
			var d:Array = e.data as Array;
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			for (var i : int = 0; i < d.length; i++) {
				var b:Bookmark = new Bookmark(d[i].name, d[i].location, 'remote', d[i].active);
				if (b.file.exists) {
					v.push(b);
				}	else{
					dispatchEvent(new UICommand(UICommand.REPAIR_BOOKMARK, b));
					return;
				}
			}
			super.redrawList(v);
			AppModel.bookmark = _list.activeItem as Bookmark;
		}		

	}
	
}
