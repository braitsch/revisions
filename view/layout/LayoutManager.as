package view.layout {
	import view.ui.DragHandle;
	import commands.UICommand;

	import flash.display.Stage;
	import flash.events.Event;

	public class LayoutManager {
		
		private static var _base	:BaseViewMC;
		private static var _stage	:Stage;
		private static var _columns	:Vector.<LiquidColumn>;
		
		public static function set stage($s:Stage):void
		{
			_stage = $s;
			_stage.addEventListener(UICommand.COLUMN_RESIZED, onColumnResize);		
			_stage.addEventListener(Event.RESIZE, onStageResize);	
		}
		
		public static function set base($b:BaseViewMC):void
		{
			_base = $b;
		}

		public static function set columns($v:Vector.<LiquidColumn>):void
		{
			_columns = $v;
			_columns[1].x = 210;
			_columns[2].x = 510;			
		}
		
		private static function onStageResize(event:Event):void 
		{               
			var w:Number = _stage.stageWidth;			var h:Number = _stage.stageHeight;
			_base.graphics.beginFill(0xE1E1E1);
			_base.graphics.drawRect(0, 90, w, h-90);
			_base.graphics.endFill();
		}		
		
		private static function onColumnResize(e:UICommand):void 
		{
			var h:DragHandle = e.target as DragHandle;
			var p:LiquidColumn = e.target.parent as LiquidColumn;
			var o:Number = h.width/2; // half the handle width //
				p.drawRedRect(h.x+o);
			_columns[1].x = _columns[0].x + _columns[0].width + 10 - o;
			_columns[2].x = _columns[1].x + _columns[1].width + 10 - o;
		}			
		
	}
}
