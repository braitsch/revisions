package view.ui {

	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ScrollingList extends Sprite {

		private var _mask			:Shape = new Shape();
		private var _view			:Sprite = new Sprite();
		private var _leading		:uint;
		private var _bottomPadding	:int;

		public function ScrollingList()
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function set leading(n:uint):void { _leading = n; }
		public function set bottomPadding(n:uint):void { _bottomPadding = n; }
		
		public function clear():void
		{
			_view.y = 0;
			while(_view.numChildren) _view.removeChildAt(0);
		}
		
		public function addItem(o:DisplayObject, n:Number = 0):void
		{
			o.y = _view.numChildren * _leading;
			_view.addChild(o);
			TweenLite.from(o, .3, {alpha:0, delay:n});
		}
		
		public function draw(w:uint, h:uint, p:uint = 2):void
		{
			_mask.graphics.clear();	
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(-p, 0, w + (p*2), h);
			_mask.graphics.endFill();
			_view.mask = _mask;
			addChild(_view);
			addChild(_mask);
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{// 8 for the other guy
			var h:uint = _view.height - _bottomPadding; // offset padding on pngs //
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
