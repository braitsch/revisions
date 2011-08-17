package view.ui {

	import events.AppEvent;
	import model.AppModel;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Preloader extends Sprite {
		
		private static var _view			:PreloaderMC = new PreloaderMC();
		private static var _bkgd			:Shape = new Shape();
		private static var _text			:TextField;
		private static var _width			:uint;
		private static var _format			:TextFormat = new TextFormat();
		private static var _label			:Sprite = new Sprite();
		private static var _progressBar		:Shape = new Shape();
		private static var _progressBkgd	:Sprite = new Sprite();
		private static var _glow			:GlowFilter = new GlowFilter(0x000000, .3, 15, 15, 3, 3);
		

		public function Preloader()
		{
			alpha = 0;
			addChild(_view);
			addLabel();
			addProgressBar();
			_bkgd.graphics.beginBitmapFill(new DkGreyPattern());
			_bkgd.graphics.drawRoundRect(-40, -40, 80, 80, 5);
			_bkgd.graphics.endFill();
			_view.addChildAt(_bkgd, 0);
			_view.filters = [_glow];
			_label.filters = [_glow];
			AppModel.engine.addEventListener(AppEvent.SHOW_LOADER, showLoader);
			AppModel.engine.addEventListener(AppEvent.HIDE_LOADER, hideLoader);			
			AppModel.engine.addEventListener(AppEvent.LOADER_TEXT, setLoaderText);		
			AppModel.engine.addEventListener(AppEvent.LOADER_PERCENT, setLoaderPercent);		
		}

		public function resize(w:uint, h:uint, offX:int = 0, offY:int = 0):void
		{
			this.x = w / 2 + offX; 
			this.y = h / 2 + offY;
		}		

	// show, hide, text & percentage //

		private function showLoader(e:AppEvent):void
		{
			setLabel(e.data.msg as String);
			_view.dark.gotoAndStop(1);
			_view.light.gotoAndPlay(1);
			_view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_progressBkgd.visible = e.data.prog || false;
			TweenLite.to(this, .5, {alpha:1});
		}
		
		private function hideLoader(e:AppEvent):void
		{
			TweenLite.to(this, .5, {alpha:0});
			_view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function setLoaderText(e:AppEvent):void
		{
			setLabel(e.data as String);
		}			
		
		private function setLoaderPercent(e:AppEvent):void
		{
			var t:uint = e.data.total;
			var l:uint = e.data.loaded;
			TweenLite.to(_progressBar, .3, {width:((_width-8) / t) * l});
		}	
		
	// draw & render methods //				
		
		private function addLabel():void
		{
			addChild(_label);
			_format.letterSpacing = 1;
			_text = _view.label_txt;
			_text.y = 4;
			_text.textColor = 0xDDDDDD;
			_text.defaultTextFormat = _format;
			_text.autoSize = TextFieldAutoSize.CENTER;
		//	_text.filters = [new GlowFilter(0x000000, .8, 3, 3, 1, 3)];
			_label.y = 48;
			_label.addChild(_text);
		}
		
		private function addProgressBar():void
		{
			_label.addChild(_progressBkgd);
			_progressBkgd.addChild(_progressBar);			
		}		
		
		private function setLabel(s:String):void
		{
			_text.text = s;
			_width = _text.width + 18;
			_label.graphics.clear();
			_label.graphics.beginBitmapFill(new DkGreyPattern());
			_label.graphics.drawRoundRect(-_width/2, 0, _width, 20, 5);
			_label.graphics.endFill();
			setProgressBar();
		}
		
		private function setProgressBar():void
		{
			_progressBkgd.y = 22;
			_progressBkgd.graphics.clear();
			_progressBkgd.graphics.beginBitmapFill(new DkGreyPattern());
			_progressBkgd.graphics.drawRoundRect(-_width/2, 0, _width, 9, 3);
			_progressBkgd.graphics.endFill();
			_progressBkgd.graphics.beginFill(0xCCCCCC, .6);
			_progressBkgd.graphics.drawRect(-_width/2 + 4, 4, _width - 8, 1);
			_progressBkgd.graphics.endFill();
			
			_progressBar.y = 4;
			_progressBar.x = -_width/2 + 4;
			_progressBar.graphics.clear();
			_progressBar.graphics.beginFill(0xffffff);
			_progressBar.graphics.drawRect(0, 0, _width - 8, 1);
			_progressBar.graphics.endFill();
			_progressBar.width = 0;
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

	}
	
}
