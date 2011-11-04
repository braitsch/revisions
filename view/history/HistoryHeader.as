package view.history {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.graphics.PatternBox;
	import view.history.combos.BranchCombo;
	import view.history.combos.ComboGroup;
	import view.history.combos.HistoryCombo;
	import view.history.combos.SyncCombo;
	import view.ui.Scroller;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class HistoryHeader extends Sprite {

		private static var _hrule		:Shape = new Shape();
		private static var _bkgd		:PatternBox = new PatternBox(new DkGreyPattern());
		private static var _scroller	:Scroller = new Scroller();
		private static var _history		:HistoryCombo = new HistoryCombo();
		private static var _merger		:SyncCombo = new SyncCombo();
		private static var _switcher	:BranchCombo = new BranchCombo();

		public function HistoryHeader()
		{
			_hrule.y = 32;
			_hrule.filters = [new DropShadowFilter(1, 90, 0, .5, 4, 4, 1, 3)];
			addChild(_bkgd); 
			addChild(_hrule); 
			addChild(_history);
			addChild(_switcher);
			addChild(_merger);
			addChild(_scroller); 
			hideAll(); // hide everything until user loads history //
			addEventListener(UIEvent.COMBO_HEADING_OVER, onComboRollOver);
			AppModel.engine.addEventListener(AppEvent.BRANCH_DELETED, drawBranchControls);
		}

		public function refresh():void
		{
			_history.draw();
			showCombo(_history);
			drawBranchControls();
		}
		
		public function hideAll(e:AppEvent = null):void
		{
			hideCombo(_history);
			hideCombo(_merger);
			hideCombo(_switcher);
		}	

		public function resize(w:uint, h:uint):void
		{
			_bkgd.draw(w, 32);
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
		
		private function drawBranchControls(e:AppEvent = null):void
		{
			if (AppModel.bookmark.branches.length > 1){
				showBranchControls();
			}	else{
				hideBranchControls();
			}			
		}		
		
		private function showBranchControls():void
		{
			_switcher.draw();
			_switcher.x = _history.x + _history.width + 1;
			showCombo(_switcher);
			_merger.draw();
			_merger.x = _switcher.x + _switcher.width + 1;
			showCombo(_merger);
		}
		
		private function hideBranchControls():void
		{
			hideCombo(_merger);
			hideCombo(_switcher);	
		}		
		
		private function onComboRollOver(e:UIEvent):void
		{
			setChildIndex(e.data as ComboGroup, numChildren - 1);	
		}
		
		private function showCombo(n:ComboGroup):void
		{
			if (n.visible == false){
				n.alpha = 0; n.visible = true;
				TweenLite.to(n, .5, {alpha:1});	
			}
		}
		
		private function hideCombo(n:ComboGroup):void
		{
			TweenLite.to(n, .5, {alpha:0, onComplete:function():void{n.visible = false;}});
		}

	}
	
}