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
		private var _bkgdColor		:uint;
		private var _bottomPadding	:int;

		public function ScrollingList()
		{
			addChild(_view);
			addChild(_mask);
			_view.mask = _mask;
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function get list():Sprite { return _view; }
		public function set leading(n:uint):void { _leading = n; }
		public function set bkgdColor(n:uint):void { _bkgdColor = n; }
		public function set bottomPadding(n:uint):void { _bottomPadding = n; }
		
		public function clear():void
		{
			while(_view.numChildren) _view.removeChildAt(0);
		}
		
		protected function showItem(k:DisplayObject, n:uint, f:Number = .5):void
		{
			if (k.stage == null){
				k.alpha = 0;
				_view.addChild(k);
				TweenLite.to(k, f, {alpha:1, delay:n * .05});
			}
		}
		
		protected function hideItem(k:DisplayObject, n:uint, f:Number = .5):void
		{
			if (k.stage != null) {
				TweenLite.to(k, f, {alpha:0, delay:n * .05, 
					onCompleteParams:[k],
					onComplete:function(k:Sprite):void { if (k.stage) _view.removeChild(k);}});
			}
		}			
		
		public function addItem(o:DisplayObject, n:Number):void
		{
			_view.addChild(o); o.y = n * _leading;
			TweenLite.from(o, .5, {alpha:0, delay:.05 * n});
		}	
		
		protected function removeItem(o:DisplayObject):void
		{
			TweenLite.to(o, .3, {alpha:0, onComplete:function():void{
				_view.removeChild(o);
				for (var i:uint = 0; i < _view.numChildren; i++) {
					TweenLite.to(_view.getChildAt(i), .3, {y:_leading * i});
				}	
			}});			
		}
		
		public function draw(w:uint, h:uint, p:uint = 0):void
		{
			_mask.graphics.clear();	
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(-p, 0, w + (p*2), h);
			_mask.graphics.endFill();
			if (_bkgdColor){
				_view.graphics.clear();	
				_view.graphics.beginFill(_bkgdColor);
				_view.graphics.drawRect(0, 0, w, _view.height);
				_view.graphics.endFill();
			}
			alignBottom();
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
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
		
		private function alignBottom():void
		{
			if (_mask.height > _view.height){
				_view.y = 0;
			}	else{
				var k:Number = _view.height - _mask.height + _view.y;
				if (k < 0) _view.y -= k;
			}			
		}

	}
	
}
