package view.ui {

	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import system.AppSettings;

	public class SmartButton extends Sprite {

		private static var _timeout	:int = 500;
		private var _view		:Sprite;
		private var _timer		:Timer = new Timer(_timeout, 1);
		private var _tooltip	:Tooltip;

		public function SmartButton(v:Sprite, t:Tooltip)
		{
			_view = v;
			_tooltip = t;
			_view.buttonMode = true;
			_view['over'].alpha = 0;			
			_view.addEventListener(MouseEvent.ROLL_OUT, onRollOut);		
			_view.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_view.addEventListener(MouseEvent.CLICK, onClick);
			_timer.addEventListener(TimerEvent.TIMER, onTimeout);
		}

		public function get view():Sprite { return _view; }			

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.currentTarget.over, .5, {alpha:1});
			if (AppSettings.getSetting(AppSettings.SHOW_TOOL_TIPS)) startTimeout();
		}

		private function onRollOut(e:MouseEvent):void
		{
			_timer.stop();
			if (_tooltip.stage) _view.stage.removeChild(_tooltip);
			TweenLite.to(e.currentTarget.over, .5, {alpha:0});
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (_tooltip.stage) _view.stage.removeChild(_tooltip);			
		}			

		private function startTimeout():void
		{
			_timer.reset();
			_timer.start();
		}
		
		private function onTimeout(e:TimerEvent):void
		{
			var p:Point = _view.parent.localToGlobal(new Point(_view.x, _view.y));
			_tooltip.x = p.x;
			_tooltip.y = p.y - 20; 
			_view.stage.addChild(_tooltip);
		}
		
	}
	
}
