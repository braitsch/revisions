package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.ScrollingList;

	public class BookmarkList extends ScrollingList {
		
		public function BookmarkList()
		{	
			super.leading = 34;
			AppModel.engine.addEventListener(BookmarkEvent.LOADED, onBookmarkList);
			AppModel.engine.addEventListener(BookmarkEvent.ADDED, onBookmarkAdded);
			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onBookmarkDeleted);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);			
		}
		
		public function resize(h:uint):void
		{
			super.draw(200, h);
		}
		
		private function onBookmarkList(e:BookmarkEvent):void 
		{
			var v:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			for (var i:int = 0; i < v.length; i++) super.addItem(new BookmarkListItem(v[i]));
		}

		private function onBookmarkAdded(e:BookmarkEvent):void 
		{
			super.addItem(new BookmarkListItem(e.data as Bookmark));
		}
		
		private function onBookmarkDeleted(e:BookmarkEvent):void 
		{
			for (var i:int = 0; i < super.list.numChildren; i++) {
				var k:BookmarkListItem = super.list.getChildAt(i) as BookmarkListItem;
				if (k.bookmark == e.data as Bookmark) super.removeItem(k);
			}
		}
		
		private function onBookmarkSelected(e:BookmarkEvent):void 
		{
			for (var i:int = 0; i < super.list.numChildren; i++) {
				var k:BookmarkListItem = super.list.getChildAt(i) as BookmarkListItem;
				k.active = (k.bookmark == AppModel.bookmark);
			}					
		}		

	}
	
}
