package view.layout {
	import events.UIEvent;

	import view.ui.UIScrollBar;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SimpleList extends Sprite {
	
		private var _width				:uint;
		private var _height 			:uint;		private var _leading			:uint = 1;
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
			
			_container.addEventListener(MouseEvent.CLICK, onItemSelection);			_container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(UIEvent.TOGGLE_DIRECTORY, onListHeightChanged);			
		}
		
	// public getters / setters //	
		
		public function get scrollbar():UIScrollBar
		{
			return _scrollbar;
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

		public function setSize(w:uint, h:uint):void		{
			_width = w;
			_height = h;
		}
		
	// protected getters //	
		
		protected function get leading():uint
		{
			return _leading;
		}				
		
		protected function get container():Sprite
		{
			return _container;
		}		
		
	// methods //
		
		public function clear():void
		{
			_activeItem = null;			
			while(_container.numChildren) {
				var i:ListItem = _container.getChildAt(0) as ListItem;
					i.removeEventListener(MouseEvent.CLICK, onItemSelection);
				_container.removeChild(i);
			}
		///	trace("SimpleList.clear()", _container.numChildren);			
		}							
		
		public function build(v:Vector.<ListItem>):void
		{
			for (var i : int = 0; i < v.length; i++) {
				var k:ListItem = v[i];
					k.y = _container.height;
				if (i > 0) k.y += _leading;
				if (k.active == 1) this.activeItem = k;
				_container.addChild(k);
			}
		// check if we need the scrollbar //	
			_scrollbar.reset();
			_scrollbar.visible = _container.height > _height;			
		}
		
		
	// private methods //	

		protected function onItemSelection(e:MouseEvent):void 
		{
			var k:DisplayObject = e.target as DisplayObject;
			while(k.parent){
				if (k is ListItem) break;			
				k = k.parent;
			}
			this.activeItem = k as ListItem;
			dispatchEvent(new UIEvent(UIEvent.FILE_SELECTED));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			_scrollbar.drawMask(_width, _height);
		}
		
		private function onListHeightChanged(e:UIEvent):void 
		{
			_scrollbar.adjustToNewListHeight();
		}		

	}
	
}
