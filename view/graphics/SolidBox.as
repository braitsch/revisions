package view.graphics {

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;

	public class SolidBox extends Shape {

		private static var _stroke		:uint = 0xcfcfcf;

		private var _color			:uint;
		private var _drawStroke		:Boolean;

		public function SolidBox(c:uint, s:Boolean = false)
		{
			_color = c;
			_drawStroke = s;
		}
		
		public function draw(w:uint, h:uint):void
		{
			graphics.clear();
			graphics.beginFill(_color);
			if (_drawStroke) graphics.lineStyle(1, _stroke, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
	}
	
}
