package view.history.switcher {

	import view.type.TextHeading;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class SwitcherItem extends Sprite {

		public static const ITEM_HEIGHT		:uint = 30;
		
		private var _bkgd			:*;
		private var _icon			:Bitmap;
		private var _text			:TextHeading;
	
		public function SwitcherItem(bkgd:Shape, icon:Bitmap, text:TextHeading)
		{
			_bkgd = bkgd; 
			_icon = icon;
			_text = text;
			_icon.x = 7;
			_icon.y = 5;
			_text.y = 9;
			_text.x = 30;
			addChild(_bkgd);		
			addChild(_icon);		
			addChild(_text);
		}
		
		
		public function draw(w:uint):void
		{
			_bkgd.draw(w, ITEM_HEIGHT);
		}	
		
	}
	
}
