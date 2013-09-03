package view.frame {

	import events.UIEvent;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Header extends Sprite {
		
		private static var _slices		:Shape = new Shape();
		private static var _appLogo	 	:Bitmap = new Bitmap(new AppLogo());
		private static var _buttons		:GlobalButtons = new GlobalButtons();
		private static var _right		:Bitmap = new Bitmap(new HeaderRight());
		private static var _dragArea	:HeaderDragArea = new HeaderDragArea();
		
		public function Header()
		{
			_appLogo.y = 6;
			addChild(_slices);
			addChild(_right);
			addChild(_dragArea);
			addChild(_appLogo);
			addChild(_buttons);
			initButtons();
			this.mouseEnabled = false;
		}

		public function resize(w:uint):void
		{
			_slices.graphics.clear();
			_slices.graphics.beginBitmapFill(new HeaderSlice());
			_slices.graphics.drawRect(_right.width-w, 0, w-_right.width, 78);
			_slices.graphics.endFill();
			_dragArea.draw(w, 67);
			_appLogo.x = w/2 - _appLogo.width/2;
			_right.x = _slices.x = _buttons.x = w-_right.width;
		}
		
		private function initButtons():void
		{
			for (var i:int = 0; i < _buttons.numChildren; i++) {
				var k:Sprite = _buttons.getChildAt(i) as Sprite;
				k.buttonMode = true;
				k['over'].alpha = 0;
				k.addEventListener(MouseEvent.CLICK, onClick);
				k.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				k.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .5, {alpha:1});
		}

		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .5, {alpha:0});
		}

		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget.name){
				case 'new_bkmk_btn' :
					dispatchEvent(new UIEvent(UIEvent.ADD_BOOKMARK));
				break;	
				case 'settings_btn' :
					dispatchEvent(new UIEvent(UIEvent.GLOBAL_SETTINGS));
				break;
				case 'help_btn' :
					navigateToURL(new URLRequest('http://revisions.braitsch.io/help'));
				break;
			}
		}
		
	}
	
}
