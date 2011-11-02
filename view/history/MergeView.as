package view.history {

	import model.vo.Commit;
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
		private static var _newCommits	:Vector.<Commit>;
		private static var _oldCommits	:Vector.<Commit>;

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
			onAddedToStage();
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
			addChild(_branchA); addChild(_branchB);
			drawLayout();
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
//			if (_newCommits && _oldCommits){
//				for (i = 0; i < _newCommits.length; i++) trace('new commits = '+_newCommits[i].note);
//				for (i = 0; i < _oldCommits.length; i++) trace('old commits = '+_oldCommits[i].note);	
//			}
			return _newCommits && _oldCommits;
		}
		
		private function onAddedToStage(e:Event = null):void
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
