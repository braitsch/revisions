package view.graphics {

	import flash.display.Shape;
	import flash.events.Event;

	public class Box extends Shape {

		public static const WHITE		:uint = 0xffffff;
		public static const DK_GREY		:uint = 0x888888;
		public static const LT_GREY		:uint = 0xC0C0C0;
		public static const STROKE		:uint = 0xCFCFCF;

		private var _height				:uint;
		private var _scaleOffset		:uint;

		public function set scalable(b:Boolean):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);			
		}
		
		public function draw(w:uint, h:uint):void 
		{ 
			_height = h;
		}		
		
		public function set scaleOffset(x:uint):void
		{
			_scaleOffset = x;	
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
			draw(stage.width - _scaleOffset, _height);
		}	
		
	}
	
}
