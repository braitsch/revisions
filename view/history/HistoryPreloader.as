package view.history {

	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.display.Sprite;

	public class HistoryPreloader extends Sprite {
		
	private static var _view:SimplePreloader = new SimplePreloader();

		public function HistoryPreloader()
		{
			alpha = 0;
			addChild(_view);
			_view.graphics.beginBitmapFill(new DkGreyPattern());
			_view.graphics.drawRoundRect(-50, -50, 100, 100, 5);
			_view.graphics.endFill();
		}

		public function show():void
		{
			TweenLite.to(this, .5, {alpha:1});
			_view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function hide():void
		{
			TweenLite.to(this, .5, {alpha:0});
			_view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_view.circle.rotation +=10;
		}		
		
	}
	
}
