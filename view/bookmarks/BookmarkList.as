package view.bookmarks {

	import model.Bookmark;
	import com.greensock.TweenLite;
	import flash.display.Sprite;

	public class BookmarkList extends Sprite {
		
		private static var _leading	:uint = 1;

		public function addItem(b:Bookmark):void 
		{
			var n:BookmarkListItem = new BookmarkListItem(b);
			n.y = (n.height + _leading) * numChildren;
			addChild(n);
		}
		
		public function removeItem(b:Bookmark):void 
		{
			for (var i:int = 0; i < numChildren; i++) {
				var k:BookmarkListItem = getChildAt(i) as BookmarkListItem;
				if (k.bookmark == b) break;
			}
			TweenLite.to(k, .3, {alpha:0, onComplete:function():void{
				removeChild(k);
				for (i = 0; i < numChildren; i++) {
					k = getChildAt(i) as BookmarkListItem;
					TweenLite.to(k, .3, {y:(k.height + _leading) * i});
				}	
			}});
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
