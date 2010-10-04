package view.layout {
	import commands.UICommand;

	import view.ui.DragHandle;
	import view.ui.UIScrollBar;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class LiquidColumn extends Sprite {

		private var _list			:SimpleList;
		private var _width			:uint;
		private var _height			:uint = 450;
		private var _handle			:DragHandle = new DragHandle();
		private var _scrollbar		:UIScrollBar = new UIScrollBar(8, _height, 8, 20);

		public function LiquidColumn() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}

		public function set list($list:SimpleList):void
		{
			_list = $list;
			_list.addEventListener(UICommand.TOGGLE_OPEN_DIRECTORY, onListHeightChanged);		
		}
		
		override public function set width(w:Number):void
		{
			_width = w;
		}	

		public function setSize($w:Number, $h:Number=0):void
		{
			$h = $h || _height;
			graphics.clear();
			graphics.lineStyle(1, 0xff0000);
			graphics.drawRect(0, 0, $w, $h);
		//	trace('$w: ' + ($w), $h);
		}

		private function onAddedToStage(e:Event):void 
		{
			setSize(_width, _height);
			_scrollbar.x = _width-8;
			_scrollbar.target = _list;
			_scrollbar.drawMask(_width, _height-_list.y);
			_scrollbar.visible = false;
			addChild(_scrollbar);						
			
			_handle.x = _width - _handle.width/2;
			_handle.y = _height/2 - _handle.height/2;		
			_handle.boundaries(new Rectangle(0, _handle.y, stage.stageWidth-20-this.x-20, 0));	
//			_handle.addEventListener()
			addChild(_handle);
		}

		private function onListHeightChanged(e:UICommand):void 
		{
			_scrollbar.handleListResize();
		}	

		protected function redrawList($v:Vector.<ListItem>):void
		{
			_list.refresh($v);
			_scrollbar.reset();
		}

	}
	
}
