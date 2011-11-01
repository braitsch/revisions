package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Branch;
	import view.graphics.PatternBox;
	import view.graphics.SolidBox;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;

	public class MergeView extends Sprite {

		private static var _bkgd		:PatternBox = new PatternBox(new LtGreyPattern());
		private static var _divider		:SolidBox = new SolidBox(0xffffff);
		private static var _width		:uint;
		private static var _height		:uint;
		private static var _branchA		:HistorySnapshot;
		private static var _branchB		:HistorySnapshot;

		public function MergeView()
		{
			addChild(_bkgd);
			addChild(_divider);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			AppModel.engine.addEventListener(AppEvent.BRANCH_HISTORY, onBranchData);
		}

		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			if (stage) drawLayout();
		}

		private function onBranchData(e:AppEvent):void
		{
			_branchA = new HistorySnapshot(AppModel.branch);
			_branchB = new HistorySnapshot(e.data as Branch);
			addChild(_branchA); addChild(_branchB);
			drawLayout();
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.alpha = 0;
			if (_branchA) {removeChild(_branchA); _branchA = null;}
			if (_branchB) {removeChild(_branchB); _branchB = null;}
		}
		
		private function drawLayout():void
		{
			_divider.x = _width / 2;
			_divider.draw(2, _height);
			_bkgd.draw(_width, _height);
			_branchA.width = _width / 2 - 1;
			_branchB.width = _width / 2 - 1;
			_branchB.x = _width / 2 + _divider.width + 1;
			TweenLite.to(this, .5, {alpha:1, delay:.3});
		}		

	}
	
}
