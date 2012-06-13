package view.graphics {

	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;

	public class GradientBox extends Box {

		private static var _color1		:uint = 0xffffff;
		private static var _color2		:uint = 0x888888;
		private var _mtrx				:Matrix = new Matrix();
		private var _ratios				:Array;
		private var _colors				:Array;
		private var _drawStroke			:Boolean = true;

		public function GradientBox(ds:Boolean = true, flip:Boolean = false)
		{
			_drawStroke = ds;
			_ratios = flip ? [0, 170] : [80, 255];
			_colors = flip ? [_color2, _color1] : [_color1, _color2];
		}
		
		override public function draw(w:uint, h:uint):void
		{
			super.draw(w, h);			
			_mtrx.createGradientBox(w, h, Math.PI / 2);	
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, w, h);
			if (_drawStroke) graphics.lineStyle(1, Box.STROKE, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.beginGradientFill(GradientType.LINEAR, _colors, [.3, .3], _ratios, _mtrx);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
	}
	
}
