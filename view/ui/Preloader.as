package view.ui {

	import flash.filters.GlowFilter;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Preloader extends Sprite {
		
	private static var _view:PreloaderMC = new PreloaderMC();

		public function Preloader()
		{
			alpha = 0;
			addChild(_view);
			_view.graphics.beginBitmapFill(new DkGreyPattern());
			_view.graphics.drawRoundRect(-40, -40, 80, 80, 5);
			_view.graphics.endFill();
			this.filters = [new GlowFilter(0x000000, .3, 15, 15, 3, 3)];
		}

		public function show():void
		{
			_view.light.gotoAndPlay(1);
			_view.dark.gotoAndStop(1);
			_view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			TweenLite.to(this, .5, {alpha:1});
		}

		private function onEnterFrame(e:Event):void
		{
			if (_view.light.currentFrame == 29) {
				_view.dark.gotoAndPlay(1);
				checkChildren(_view.light, _view.dark);
			}
			if (_view.dark.currentFrame == 29) {
				checkChildren(_view.dark, _view.light);
				_view.light.gotoAndPlay(1);
			}
		}
		
		private function checkChildren(a:Sprite, b:Sprite):void
		{
			if (_view.getChildIndex(a) > _view.getChildIndex(b)) _view.swapChildren(a, b);
		}

		public function hide():void
		{
			TweenLite.to(this, .5, {alpha:0});
			_view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}
	
}
