package view.layout {
	import flash.events.Event;
	import commands.UICommand;

	import view.ui.UIScrollBar;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SimpleList extends Sprite {
	
		private var _width				:uint;
		private var _height 			:uint;		private var _leading			:uint = 2;
		private var _container			:Sprite;
		private var _scrollbar			:UIScrollBar;
		private var _activeItem			:ListItem;

		public function SimpleList()
		{
			_container = new Sprite();
			addChild(_container);
			
			_scrollbar = new UIScrollBar(8, 330, 8, 20);
			_scrollbar.visible = false;
			_scrollbar.target = _container;
			addChild(_scrollbar);
			
			_container.addEventListener(MouseEvent.CLICK, onItemSelection);
			_container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UICommand.TOGGLE_OPEN_DIRECTORY, onListHeightChanged);			
		}
		
		public function get container():Sprite
		{
			return _container;
		}		
		
		public function get scrollbar():UIScrollBar
		{
			return _scrollbar;
		}		

		public function setSize(w:uint, h:uint):void		{
			_width = w;
			_height = h;
		}
		
		public function clear():void
		{
			_activeItem = null;			
			while(_container.numChildren) {
				var i:ListItem = _container.getChildAt(0) as ListItem;
					i.removeEventListener(MouseEvent.CLICK, onItemSelection);
				_container.removeChild(i);
			}			
		}		
		
		public function refresh(v:Vector.<ListItem>):void
		{
			clear();
			for (var i : int = 0; i < v.length;i++) {
				var n:ListItem = v[i];
				n.y = (n.height + _leading) * i;
				if (n.active == 1) this.activeItem = n;
				_container.addChild(n);
			}
		// check if we need the scrollbar //	
			_scrollbar.reset();
			_scrollbar.visible = _container.height > _height;			
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

		private function onAddedToStage(e:Event):void 
		{
			_scrollbar.drawMask(_width, _height);
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
		
		private function onListHeightChanged(e:UICommand):void 
		{
			_scrollbar.adjustToNewListHeight();
		}		
		
	}
	
}
