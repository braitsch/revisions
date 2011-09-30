package view.history.switcher {

	import view.btns.ButtonIcon;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.type.TextHeading;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SwitcherItem extends Sprite {

		public static const ITEM_HEIGHT		:uint = 30;
		
		private var _bkgd			:Box;
		private var _icon			:ButtonIcon;
		private var _over			:SolidBox = new SolidBox(Box.WHITE);
		private var _text			:TextHeading;
	
		public function SwitcherItem(bkgd:Box, icon:ButtonIcon, text:TextHeading)
		{
			_bkgd = bkgd; 
			_icon = icon;
			_text = text;
			_icon.y = 16;
			_icon.x = 20;
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
