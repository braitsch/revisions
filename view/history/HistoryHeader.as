package view.history {

	import events.AppEvent;
	import model.AppModel;
	import view.history.merger.BranchMerger;
	import view.history.switcher.BranchSwitcher;
	import view.ui.Scroller;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class HistoryHeader extends Sprite {

		private static var _hrule		:Shape = new Shape();
		private static var _pattern		:Shape = new Shape();
		private static var _title		:HistoryTitle = new HistoryTitle();
		private static var _switcher	:BranchSwitcher = new BranchSwitcher();
		private static var _merger		:BranchMerger = new BranchMerger();
		private static var _scroller	:Scroller = new Scroller();

		public function HistoryHeader()
		{
			_hrule.y = 32;
			_hrule.filters = [new DropShadowFilter(1, 90, 0, .5, 4, 4, 1, 3)];
			addChild(_pattern); 
			addChild(_scroller); 
			addChild(_hrule); 
			addChild(_title);
			addChild(_switcher);
			addChild(_merger);
			AppModel.engine.addEventListener(AppEvent.BRANCH_DELETED, onBranchDeleted);
		}

		private function onBranchDeleted(e:AppEvent):void
		{
			refresh();
		}
		
		public function clear():void
		{
			_title.visible = _switcher.visible = _merger.visible = false;
		}

		public function refresh():void
		{
			_title.draw(); _switcher.draw(); _merger.draw();
			_switcher.x = _title.x + _title.width + 1;
			_merger.x = _switcher.x + _switcher.width + 1;
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