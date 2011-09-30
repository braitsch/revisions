package view.btns {

	import flash.filters.GlowFilter;
	import view.graphics.Box;
	import flash.display.Sprite;
	public class ButtonIcon extends Sprite {

		private var _btn			:Sprite;
		private static var _glow	:GlowFilter = new GlowFilter(0xffffff, .8, 10, 10, 3, 3);

		public function ButtonIcon(b:Sprite, t:Boolean = true)
		{
			_btn = b;
			if (t) _btn.transform.colorTransform = Box.TINT;
			addChild(_btn);
			filters = [_glow];
		}
		
	}
	
}
