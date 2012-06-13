package view.graphics {

	import flash.display.Shape;
	import flash.geom.ColorTransform;

	public class Box extends Shape {

		public static const WHITE		:uint = 0xffffff;
		public static const DK_GREY		:uint = 0x888888;
		public static const LT_GREY		:uint = 0xC0C0C0;
		public static const STROKE		:uint = 0x999999; //0xCFCFCF;
		public static const	TINT		:ColorTransform = new ColorTransform();	
							TINT.color = 0x999999;

		public function draw(w:uint, h:uint):void { }
		
	}
	
}
