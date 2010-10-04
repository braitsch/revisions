package view.ui {
	import commands.UICommand;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class DragHandle extends Sprite {

		private var _boundaries:Rectangle;
		
		public function DragHandle()
		{
		//	visible = false;
			buttonMode = true;
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, 10, 30);
			addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);			
		}

		private function onHandleDown(e:MouseEvent):void 
		{
			startDrag(false, _boundaries);
			addEventListener(Event.ENTER_FRAME, onHandleDrag);			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUP);
		}
		private function onHandleDrag(e:Event):void 
		{
			dispatchEvent(new UICommand(UICommand.COLUMN_RESIZED, this));
		}

		private function onStageMouseUP(event:MouseEvent):void 
		{
			stopDrag();
			removeEventListener(Event.ENTER_FRAME, onHandleDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUP);
		}

		public function boundaries(b:Rectangle):void 
		{
			_boundaries = b;
		}
	}
}
