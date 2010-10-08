package view.layout {
	import commands.UICommand;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SimpleList extends Sprite {
	
		private static var _leading		:uint = 2;
		protected var list				:Sprite;
		private var _activeItem			:ListItem;	

		public function SimpleList()
		{
			list = new Sprite();
			list.addEventListener(MouseEvent.CLICK, onItemSelection);			
			addChild(list);
		}
		
		public function refresh(v:Vector.<ListItem>):void
		{
			clear();
			for (var i : int = 0; i < v.length;i++) {
				var n:ListItem = v[i];
				n.y = (n.height+_leading) * i;
				if (n.active == 1) this.activeItem = n;
				list.addChild(n);
			}
		}
		
		public function get activeItem():ListItem
		{
			return _activeItem;
		}			
		
		public function set activeItem($n:ListItem):void
		{
			if (_activeItem) _activeItem.active = false;
			_activeItem = $n;
			_activeItem.active = true;
		}
		
	// private methods //	
		
		private function clear():void
		{
			_activeItem = null;			
			while(list.numChildren) {
				var i:ListItem = list.getChildAt(0) as ListItem;
					i.removeEventListener(MouseEvent.CLICK, onItemSelection);
				list.removeChild(i);
			}			
		}
		
		private function onItemSelection(e:MouseEvent):void 
		{
			var k:DisplayObject = e.target as DisplayObject;
			while(k.parent){
				if (k is ListItem) break;			
				k = k.parent;
			}
			this.activeItem = k as ListItem;
			dispatchEvent(new UICommand(UICommand.LIST_ITEM_SELECTED));
		}
		
	}
	
}
