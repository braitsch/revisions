package view.bookmarks {
	import model.Bookmark;
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
		}

		public function addItem(n:ListItem):void 
		{
			n.y = super.container.height + super.leading;
			super.container.addChild(n);
		}
		
		public function removeItem(n:ListItem):void 
		{
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			for (var i:int = 0; i < super.container.numChildren; i++) {
				var k:ListItem = super.container.getChildAt(i) as ListItem;
				if (k.file != n.file) v.push(k);
			}
			super.clear();
			super.build(v);
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
