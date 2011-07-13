package view.ui {

	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Preloader extends Sprite {
		
		private static var _view		:PreloaderMC = new PreloaderMC();
		private static var _bkgd		:Shape = new Shape();
		private static var _text		:TextField;
		private static var _format		:TextFormat = new TextFormat();
		private static var _label		:Sprite = new Sprite();
		private static var _glow		:GlowFilter = new GlowFilter(0x000000, .3, 15, 15, 3, 3);

		public function Preloader()
		{
			alpha = 0;
			addChild(_view);
			addChild(_label);
			addLabel();
			_bkgd.graphics.beginBitmapFill(new DkGreyPattern());
			_bkgd.graphics.drawRoundRect(-40, -40, 80, 80, 5);
			_bkgd.graphics.endFill();
			_view.addChildAt(_bkgd, 0);
			_view.filters = [_glow];
			_label.filters = [_glow];
		}

		public function set label(s:String):void
		{
			_text.text = s;
			var w:Number = _text.width + 18;
			_label.graphics.clear();
			_label.graphics.beginBitmapFill(new DkGreyPattern());
			_label.graphics.drawRoundRect(-w/2, 0, w, 20, 5);
			_label.graphics.endFill();			
		}

		public function show():void
		{
			_view.light.gotoAndPlay(1);
			_view.dark.gotoAndStop(1);
			_view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			TweenLite.to(this, .5, {alpha:1});
		}
		
		public function resize(w:uint, h:uint, offX:int = 0, offY:int = 0):void
		{
			this.x = w / 2 + offX; 
			this.y = h / 2 + offY;
		}
		
		private function addLabel():void
		{
			_format.letterSpacing = 1;
			_text = _view.label_txt;
			_text.y = 4;
			_text.textColor = 0xDDDDDD;
			_text.defaultTextFormat = _format;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.filters = [new GlowFilter(0x000000, .8, 3, 3, 1, 3)];
			_label.y = 48;
			_label.addChild(_text);
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
