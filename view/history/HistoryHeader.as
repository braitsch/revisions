package view.history {

	import view.history.combos.ComboGroup;
	import events.UIEvent;
	import events.AppEvent;
	import model.AppModel;
	import view.graphics.PatternBox;
	import view.history.combos.BranchMerger;
	import view.history.combos.BranchSwitcher;
	import view.history.combos.HistoryChooser;
	import view.ui.Scroller;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class HistoryHeader extends Sprite {

		private static var _hrule		:Shape = new Shape();
		private static var _pattern		:PatternBox = new PatternBox(new DkGreyPattern());
		private static var _history		:HistoryChooser = new HistoryChooser();
		private static var _merger		:BranchMerger = new BranchMerger();
		private static var _switcher	:BranchSwitcher = new BranchSwitcher();
		private static var _scroller	:Scroller = new Scroller();

		public function HistoryHeader()
		{
			_hrule.y = 32;
			_hrule.filters = [new DropShadowFilter(1, 90, 0, .5, 4, 4, 1, 3)];
			addChild(_pattern); 
			addChild(_scroller); 
			addChild(_hrule); 
			addChild(_history);
			addChild(_switcher);
			addChild(_merger);
			addEventListener(UIEvent.COMBO_HEADING_OVER, onComboRollOver);
			AppModel.engine.addEventListener(AppEvent.BRANCH_DELETED, onBranchDeleted);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_EDITED, onBookmarkEdited);
		}

		public function clear():void
		{
			_history.visible = _switcher.visible = _merger.visible = false;
		}

		public function refresh():void
		{
			_history.draw(); _switcher.draw(); _merger.draw();
			_switcher.x = _history.x + _history.width + 1;
			_merger.x = _switcher.x + _switcher.width + 1;
		}
		
		public function resize(w:uint, h:uint):void
		{
			_pattern.draw(w, 32);
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
		
		private function onComboRollOver(e:UIEvent):void
		{
			setChildIndex(e.data as ComboGroup, numChildren - 1);	
		}
		
		private function onBranchDeleted(e:AppEvent):void
		{
			refresh();
		}				
		
		private function onBookmarkEdited(e:AppEvent):void
		{
			refresh();	
		}

	}
	
}