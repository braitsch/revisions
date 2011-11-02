package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Commit;
	import view.graphics.PatternBox;
	import view.graphics.SolidBox;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	public class MergeView extends Sprite {

		private static var _bkgd		:PatternBox = new PatternBox(new LtGreyPattern());
		private static var _divider		:SolidBox = new SolidBox(0xffffff);
		private static var _width		:uint;
		private static var _height		:uint;
		private static var _branchA		:HistorySnapshot;
		private static var _branchB		:HistorySnapshot;
		private static var _aUnique		:Vector.<Commit>;
		private static var _bUnique		:Vector.<Commit>;
		private static var _abShared	:Vector.<Commit>;

		public function MergeView()
		{
			addChild(_bkgd);
			addChild(_divider);
			AppModel.engine.addEventListener(AppEvent.BRANCH_HISTORY, onBranchData);
			AppModel.engine.addEventListener(AppEvent.HIDE_MERGE_VIEW, onHideMergeView);
		}

		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			if (_branchA && _branchB) drawLayout();
		}
		
		private function onBranchData(e:AppEvent):void
		{
			if (e.data.common == AppModel.branch.lastCommit.sha1){
				trace('branches are the same'); return;
			}	else{
				_bUnique = e.data.unique;
			// find the common parent commit between a & b //	
				for (var i:int = AppModel.branch.history.length-1; i > 0; i--) if (AppModel.branch.history[i].sha1 == e.data.common) break;
				_aUnique = AppModel.branch.history.slice(i + 1);
			}
			_abShared = AppModel.branch.history.slice(i - HistoryList.ITEMS_PER_PAGE, i + 1);
		// rewrite branchB indices so they extend the count from the shared array //	
			for (i = 0; i < _bUnique.length; i++) _bUnique[i].index = _abShared.length + (i + 1);
			_aUnique.reverse(); _bUnique.reverse(); _abShared.reverse();
			_branchA = new HistorySnapshot(_aUnique, _abShared);
			_branchB = new HistorySnapshot(_bUnique, _abShared);
			drawLayout();
			setTimeout(onListsRendered, 1000);
		}
		
		private function onListsRendered():void
		{
			this.visible = true;
			TweenLite.to(this, .5, {alpha:1});
			TweenLite.from(_branchA, .5, {alpha:0});
			TweenLite.from(_branchB, .5, {alpha:0});
			addChild(_branchA); addChild(_branchB);
			while ( numChildren > 4 ) removeChildAt(2);
			AppModel.hideLoader();
		}
		
		private function drawLayout():void
		{
			_divider.x = _width / 2;
			_divider.draw(2, _height);
			_bkgd.draw(_width, _height);
			_branchA.width = _width / 2;
			_branchB.width = _width / 2;
			_branchB.x = _width / 2 + _divider.width;
		}
		
		private function onHideMergeView(e:AppEvent):void
		{
			TweenLite.to(this, .5, {alpha:0, delay:.3, visible:false});	
		}				

	}
	
}
