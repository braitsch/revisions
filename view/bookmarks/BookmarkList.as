package view.bookmarks {

	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;

	public class BookmarkList extends Sprite {
		
		private static var _leading:uint = 1;

		public function BookmarkList()
		{	
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

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
		
		private function onMouseOver(e:MouseEvent):void
		{
			BookmarkListItem(e.target).active = true;
		}

		private function onMouseOut(e:MouseEvent):void
		{
			var b:BookmarkListItem = e.target as BookmarkListItem;
			if (b.bookmark != AppModel.bookmark) b.active = false;
		}		
				
	}
	
}
