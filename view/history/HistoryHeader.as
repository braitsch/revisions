package view.history {

	import model.AppModel;
	import view.type.ColumnHeading;
	import view.ui.Scroller;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class HistoryHeader extends Sprite {

		private static var _hrule		:Shape = new Shape();
		private static var _pattern		:Shape = new Shape();
		private static var _switcher	:BranchSwitcher = new BranchSwitcher();
		private static var _scroller	:Scroller = new Scroller();
		private static var _heading		:ColumnHeading = new ColumnHeading();

		public function HistoryHeader()
		{
			_hrule.y = 32; _heading.y = 12;
			_hrule.filters = [new DropShadowFilter(1, 90, 0, .5, 4, 4, 1, 3)];
			
			addChild(_pattern); 
			addChild(_scroller); 
			addChild(_hrule); 
			addChild(_heading);
			addChild(_switcher);
		}
		
		public function clear():void
		{
			_heading.text = '';
			_switcher.visible = false;
		}

		public function refresh():void
		{
			_heading.text =	'History of '+AppModel.bookmark.label;
			_switcher.redraw();
			_switcher.x = _heading.width + 20;
		}
		
		public function resize(w:uint, h:uint):void
		{
			_pattern.graphics.clear();
			_pattern.graphics.beginBitmapFill(new DkGreyPattern());
			_pattern.graphics.drawRect(0, 0, w, 32);
			_pattern.graphics.endFill();			
			_scroller.x = w - 5;
			_scroller.draw(h);
			drawHRule(w);
		}

		private function drawHRule(w:uint):void
		{
			_hrule.graphics.clear();
			_hrule.graphics.beginFill(0x000000);
			_hrule.graphics.drawRect(0, 0, w, 1);
			_hrule.graphics.beginFill(0xb3b3b3);
			_hrule.graphics.drawRect(0, 1, w, 1);
			_hrule.graphics.endFill();			
		}

	}
	
}
