package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Branch;
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
		private static var _newCommits	:Vector.<Commit>;
		private static var _oldCommits	:Vector.<Commit>;

		public function MergeView()
		{
			addChild(_bkgd);
			addChild(_divider);
			AppModel.engine.addEventListener(AppEvent.BRANCH_HISTORY, onBranchData);
		}

		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			if (_branchA && _branchB) drawLayout();
		}
		
		public function hide():void
		{
			TweenLite.to(this, .5, {alpha:0, delay:.3, visible:false});
		}
		
		private function onBranchData(e:AppEvent):void
		{
			var a:Vector.<Commit> = AppModel.branch.history.slice(-25).reverse();
			var b:Vector.<Commit> = Branch(e.data).history.slice(-25).reverse();
			if (a[0].sha1 == b[0].sha1){
				trace('branches are the same');
			}	else if (compare(a, b)) {
		//		trace('a is larger');
				_branchA = new HistorySnapshot(_oldCommits, _newCommits);
				_branchB = new HistorySnapshot(_oldCommits);
			}	else if (compare(b, a)) {
		//		trace('b is larger');
				_branchA = new HistorySnapshot(_oldCommits);
				_branchB = new HistorySnapshot(_oldCommits, _newCommits);
			}
			drawLayout();
			setTimeout(onListsRendered, 1500);
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

		private function compare(a:Vector.<Commit>, b:Vector.<Commit>):Boolean
		{
			_newCommits = null; _oldCommits = null;
			for (var i:int = 0; i < a.length; i++) {
				if (a[i].sha1 == b[0].sha1){
					_newCommits = a.slice(0, i);
					_oldCommits = a.slice(i, a.length);
				}
			}
			return _newCommits && _oldCommits;
		}
		
		private function drawLayout():void
		{
			_divider.x = _width / 2;
			_divider.draw(2, _height);
			_bkgd.draw(_width, _height);
			_branchA.width = _width / 2 - 1;
			_branchB.width = _width / 2 - 1;
			_branchB.x = _width / 2 + _divider.width + 1;
		}		

	}
	
}
