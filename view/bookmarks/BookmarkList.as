package view.bookmarks {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.ScrollingList;

	public class BookmarkList extends ScrollingList {
		
		public function BookmarkList()
		{	
			super.leading = 34;
			AppModel.engine.addEventListener(AppEvent.BOOKMARKS_LOADED, onBookmarkList);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_ADDED, onBookmarkAdded);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_DELETED, onBookmarkDeleted);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_SELECTED, onBookmarkSelected);			
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
				k.active = (k.bookmark == AppModel.bookmark);
			}					
		}		

	}
	
}
