package view.bookmarks {
	import view.layout.ListItem;
	import view.layout.SimpleList;

	public class BookmarkList extends SimpleList {

		public function BookmarkList()
		{
			
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
				k.y = (k.height + super.leading) * i;
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
