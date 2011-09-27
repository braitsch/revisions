package view {

	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Box extends Shape {
	
		public static const WHITE		:uint = 0xffffff;
		public static const DK_GREY		:uint = 0x888888;
		public static const LT_GREY		:uint = 0xC0C0C0;
		
		private var _width				:uint;
		private var _height				:uint;
		private var _color1				:uint;
		private var _color2				:uint;
		private var _stroke				:int = -1;
		private var _draw				:Function;
		private var _mtrx				:Matrix;
		private var _scaleOffset		:uint;
		private var _ratios				:Array;
		private var _pattern			:BitmapData;
	
		public function Box(w:uint, h:uint, c1:uint, c2:int = -1, flip:Boolean = false)
		{
			_width = w; _height = h;
			_color1 = c1; _color2 = c2;
			if (c2 == -1){
				_draw = drawSolid;
			}	else{
				_draw = drawGradient;
				_mtrx = new Matrix();
				_mtrx.createGradientBox(_width, _height, Math.PI / 2);
				_ratios = flip ? [0, 170] : [80, 255];
			}
			_draw();
		}
		
		public function set stroke(n:uint):void
		{
			_stroke = n; _draw();
		}
		
		public function set pattern(b:BitmapData):void
		{
			_pattern = b;
		}

		public function set scalable(b:Boolean):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);			
		}
		
		public function set scaleOffset(x:uint):void
		{
			_scaleOffset = x;	
		}
		
		private function drawSolid():void
		{
			graphics.clear();
			graphics.beginFill(_color1);
			if (_stroke > -1 ) graphics.lineStyle(1, _stroke, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			if (_pattern) graphics.beginBitmapFill(_pattern);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();			
		}
		
		private function drawGradient():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, _width, _height);
			if (_stroke > -1 ) graphics.lineStyle(1, _stroke, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.beginGradientFill(GradientType.LINEAR, [_color1, _color2], [.3, .3], _ratios, _mtrx);
			if (_pattern) graphics.beginBitmapFill(_pattern);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
		private function onAddedToStage(e:Event):void
		{
			onResize(e);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, onResize);
		}
	
		private function onResize(e:Event):void
		{
			graphics.clear();
			_width = stage.width - _scaleOffset;
			_draw();
		}
		
	}

}