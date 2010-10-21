package view.bookmarks {
	import view.layout.ListItem;
	import view.layout.SimpleList;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class BookmarkList extends SimpleList {

		override protected function onItemSelection(e:MouseEvent):void 
		{
			var k:DisplayObject = e.target as DisplayObject;
			while(k.parent){
				if (k is ListItem) break;			
				k = k.parent;
			}
			super.activeItem = k as ListItem;
//			if (e.target is BookmarkItem){
//				trace('BookmarkItem ::', e.target.bookmark.label);
//				dispatchEvent(new UICommand(UICommand.BOOKMARK_SELECTED, e.target.bookmark));					//			}
//			if (e.target is BookmarkItemBranch){
//				trace('BookmarkItemBranch ::', e.target.branch.name);	
//			}
		}

		public function addItem(n:ListItem):void 
		{
			n.y = (n.height + super.leading) * super.container.numChildren;
			super.container.addChild(n);
		}
		
		public function removeItem(n:ListItem):void 
		{
			var i:int;
			var k:ListItem;
			for (i = 0; i < super.container.numChildren; i++) {
				k = super.container.getChildAt(i) as ListItem;
				if (k.file == n.file) break;
			}
			super.container.removeChildAt(i);
			for (i = 0; i < super.container.numChildren; i++) {
				k = super.container.getChildAt(i) as ListItem;
				k.y = super.container.height + super.leading;
			}
		}
		
		public function setActiveBookmark(b:Bookmark):void
		{
			for (var i:int = 0; i < super.container.numChildren; i++) {
				var k:ListItem = super.container.getChildAt(i) as ListItem;
				if (k.file == b.file) super.activeItem = k;
			}			
		}
				
	}
	
}
