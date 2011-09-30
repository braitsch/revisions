package view.history.switcher {

	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class SwitcherItem extends Sprite {

		public static const ITEM_HEIGHT		:uint = 30;
		
		private var _bkgd			:Box;
		private var _icon			:Bitmap;
		private var _over			:SolidBox = new SolidBox(Box.WHITE);
		private var _text			:TextHeading;
	
		public function SwitcherItem(bkgd:Box, icon:Bitmap, text:TextHeading)
		{
			_bkgd = bkgd; 
			_icon = icon;
			_text = text;
			_icon.x = 10;
			_icon.y = 6;
			_text.y = 9;
			_text.x = 35;
			_over.alpha = 0;
			addChild(_bkgd);		
			addChild(_over);		
			addChild(_icon);	
			addChild(_text);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:1});
		}

		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:0});
		}

		override public function get width():Number
		{
			return _text.x + _text.width;
		}		
		
		public function draw(w:uint):void
		{
			_over.draw(w, ITEM_HEIGHT);
			_bkgd.draw(w, ITEM_HEIGHT);
		}	
		
	}
	
}
