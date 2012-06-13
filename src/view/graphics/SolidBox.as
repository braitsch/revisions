package view.graphics {

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;

	public class SolidBox extends Box {

		private var _color			:uint;
		private var _drawStroke		:Boolean;

		public function SolidBox(c:uint, s:Boolean = false)
		{
			_color = c;
			_drawStroke = s;
		}
		
		override public function draw(w:uint, h:uint):void
		{
			super.draw(w, h);
			graphics.clear();
			graphics.beginFill(_color);
			if (_drawStroke) graphics.lineStyle(1, Box.STROKE, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
	}
	
}
