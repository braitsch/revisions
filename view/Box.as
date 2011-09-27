package view {

	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Box extends Shape {
	
		private var _width					:uint;
		private var _height					:uint;
		private var _draw					:Function;
		private var _mtrx					:Matrix = new Matrix();
		private var _scaleOffset			:uint;
		
		public static const	SOLID			:String = 'solid';
		public static const	STROKE			:String = 'stroke';
		public static const	GRADIENT		:String = 'gradient';
		public static const	INVERSE			:String = 'inverse';
		
		private static const WHITE			:uint = 0xffffff;
		private static const DK_GREY		:uint = 0x888888;
		private static const STROKE_GREY	:uint = 0xC0C0C0;		
	
		public function Box(w:uint, h:uint, type:String = GRADIENT)
		{
			_width = w; _height = h;
			setBoxType(type);
		}

		private function setBoxType(type:String):void
		{
			switch(type){
				case SOLID : 
					_draw = drawWhite;
				break;
				case GRADIENT : 
					_draw = drawGradient;
					_mtrx.createGradientBox(_width, _height, Math.PI / 2);
				break;
				case INVERSE : 
					_draw = drawGradientInverse;
					_mtrx.createGradientBox(_width, _height, Math.PI / 2);
				break;
				case STROKE	: 
					_draw = drawStroke;
				break;												
			}
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
		
		private function drawWhite():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();			
		}
		
		private function drawGradient():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, _width, _height);			
			graphics.beginGradientFill(GradientType.LINEAR, [WHITE, DK_GREY], [.3, .3], [80, 255], _mtrx);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
		private function drawGradientInverse():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, _width, _height);
			graphics.beginGradientFill(GradientType.LINEAR, [DK_GREY, WHITE], [.3, .3], [0, 170], _mtrx);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
		private function drawStroke():void
		{
			graphics.clear();
			graphics.lineStyle(1, STROKE_GREY, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
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