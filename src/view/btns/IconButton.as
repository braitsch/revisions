package view.btns {

	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import view.ui.Tooltip;
	
	public class IconButton extends EventDispatcher {
		
		private var _btn		:Sprite;
		private var _tooltip	:Tooltip;

		public function IconButton(b:Sprite, s:String = '')
		{
			_btn = b;
			_btn['over'].alpha = 0;
			_btn.mouseChildren = false;
			enabled = true;
			if (s) addTooltip(s);
		}
		
		public function set x(x:int):void {_btn.x = x; }
		public function set y(y:int):void {_btn.y = y; }
		public function addTo(o:DisplayObjectContainer):void { o.addChild(_btn); }

		public function set enabled(b:Boolean):void
		{
			if (b){
				_btn.alpha = 1;
				_btn.buttonMode = true;
				_btn.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				_btn.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}	else{
				_btn.alpha = .5;
				_btn.buttonMode = false;
				_btn.removeEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				_btn.removeEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}
			_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		public function get enabled():Boolean
		{
			return _btn.alpha == 1;
		}
		
		private function addTooltip(s:String):void
		{
			_tooltip = new Tooltip(s);
			_tooltip.button = _btn;
		}
		
		private function onButtonClick(e:MouseEvent):void
		{
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}		
		
		private function onButtonRollOver(e:MouseEvent):void 
		{
			if (_tooltip) _tooltip.show();
			TweenLite.to(e.target.over, .5, {alpha:1});
		}		
		
		private function onButtonRollOut(e:MouseEvent):void 
		{
			if (_tooltip) _tooltip.hide();
			TweenLite.to(e.target.over, .3, {alpha:0});
		}
		
	}
	
}
