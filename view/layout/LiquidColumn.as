package view.layout {
	import view.ui.DragHandle;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class LiquidColumn extends Sprite {

		private var _width			:uint;
		private var _height			:uint = 450;
		private var _handle			:DragHandle = new DragHandle();

		public function LiquidColumn() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}

		override public function set width(w:Number):void
		{
			_width = w;
		}	

		public function drawRedRect($w:Number, $h:Number=0):void
		{
			$h = $h || _height;
			graphics.clear();
			graphics.lineStyle(1, 0xff0000);
			graphics.drawRect(0, 0, $w, $h);
		}

		private function onAddedToStage(e:Event):void 
		{
			drawRedRect(_width, _height);						
			
			_handle.x = _width - _handle.width/2;
			_handle.y = _height/2 - _handle.height/2;		
			_handle.boundaries(new Rectangle(0, _handle.y, stage.stageWidth-20-this.x-20, 0));	
			addChild(_handle);
		}	

	}
	
}
