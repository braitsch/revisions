package view.bookmarks {

	import model.Bookmark;
	import flash.display.Sprite;

	public class BookmarkList extends Sprite {
		
		private static var _leading	:uint = 1;

		public function addItem(n:BookmarkListItem):void 
		{
			n.y = (n.height + _leading) * numChildren;
			addChild(n);
		}
		
		public function removeItem(n:BookmarkListItem):void 
		{
			removeChild(n);
			for (var i:int = 0; i < numChildren; i++) {
				var k:BookmarkListItem = getChildAt(i) as BookmarkListItem;
				k.y = (k.height + _leading) * i;
			}
		}
		
		public function setActiveBookmark(b:Bookmark):void
		{
			for (var i:int = 0; i < numChildren; i++) {
				var k:BookmarkListItem = getChildAt(i) as BookmarkListItem;
				k.active = (k.bookmark == b);
			}			
		}
				
	}
	
}
