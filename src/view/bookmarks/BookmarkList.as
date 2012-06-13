package view.bookmarks {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.ScrollingList;

	public class BookmarkList extends ScrollingList {
		
		private static var _active	:BookmarkListItem;
		
		public function BookmarkList()
		{	
			super.leading = 34;
			AppModel.engine.addEventListener(AppEvent.BOOKMARKS_LOADED, onBookmarkList);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_ADDED, onBookmarkAdded);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_DELETED, onBookmarkDeleted);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_SELECTED, onBookmarkSelected);			
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_EDITED, onBookmarkEdited);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_REPAIRED, onBookmarkRepaired);
		}

		public function resize(h:uint):void
		{
			super.draw(200, h);
		}
		
		private function onBookmarkList(e:AppEvent):void 
		{
			var v:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			for (var i:int = 0; i < v.length; i++) super.addItem(new BookmarkListItem(v[i]), i);
		}

		private function onBookmarkAdded(e:AppEvent):void 
		{
			super.addItem(new BookmarkListItem(e.data as Bookmark), super.list.numChildren);
		}
		
		private function onBookmarkDeleted(e:AppEvent):void 
		{
			for (var i:int = 0; i < super.list.numChildren; i++) {
				var k:BookmarkListItem = super.list.getChildAt(i) as BookmarkListItem;
				if (k.bookmark == e.data as Bookmark) super.removeItem(k);
			}
		}
		
		private function onBookmarkSelected(e:AppEvent):void 
		{
			for (var i:int = 0; i < super.list.numChildren; i++) {
				var k:BookmarkListItem = super.list.getChildAt(i) as BookmarkListItem;
				if (k.bookmark == AppModel.bookmark){
					_active = k;
					k.active = true;
				}	else{
					k.active = false;	
				}
			}					
		}
		
		private function onBookmarkEdited(e:AppEvent):void
		{
			_active.setLabel();
		}
		
		private function onBookmarkRepaired(e:AppEvent):void
		{
			_active.setLabel();	
			_active.attachIcon();
		}					

	}
	
}
