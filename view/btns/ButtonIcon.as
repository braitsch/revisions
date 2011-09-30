package view.btns {

	import view.graphics.Box;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	public class ButtonIcon extends Sprite {

		private var _btn			:DisplayObject;
		private static var _glow	:GlowFilter = new GlowFilter(0xffffff, .8, 10, 10, 3, 3);

		public function ButtonIcon(b:DisplayObject, t:Boolean = true, g:Boolean = true)
		{
			_btn = b;
			if (t) _btn.transform.colorTransform = Box.TINT;
			addChild(_btn);
			if (g) filters = [_glow];
		}
		
	}
	
}
