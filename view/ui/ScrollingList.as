package view.ui {

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ScrollingList extends Sprite {

		private var _mask		:Shape = new Shape();
		private var _view		:Sprite = new Sprite();
		private var _height		:uint;

		public function ScrollingList(h:uint)
		{
			_height = h;
			addChild(_mask);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function clear():void
		{
			while(_view.numChildren) _view.removeChildAt(0);
		}
		
		public function addItem(o:DisplayObject):void
		{
			_view.addChild(o);	
		}
		
		public function draw(w:uint):void
		{
			_mask.graphics.clear();	
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(-2, 0, w + 4, _height);
			_mask.graphics.endFill();
			_view.mask = _mask;
			addChild(_view);
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			var h:uint = _view.height - 8; // offset padding on pngs //
			if (h <= _mask.height) return;
			_view.y += e.delta;
			var minY:int = _mask.height - h;
			if (_view.y >= 0) {
				_view.y = 0;
			}	else if (_view.y < minY){
				_view.y = minY;
			}
		}		
		
	}
	
}
