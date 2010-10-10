package view.history {
	import commands.UICommand;

	import model.AppModel;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _bookmark		:Bookmark;
		private var _list			:HistoryList;

		public function HistoryCollection($b:Bookmark)
		{
			_bookmark = $b;
			var a:Array = _bookmark.branches;
			for (var i:int = 0; i < a.length; i++) {
				var k:HistoryList = new HistoryList(a[i], i);
				if (a[i]==_bookmark.branch) _list = k;
				addChild(k);
			}
			_list.active = true;
			addEventListener(UICommand.BRANCH_SELECTED, onBranchSelected);
		}
		
		public function set branch(b:Branch):void
		{
			_list.active = false;
			for (var i:int = 0; i < numChildren; i++) {
				var k:HistoryList = getChildAt(i) as HistoryList;
				if (k.branch==b){
					_list = k;					_list.active = true;
					setChildIndex(_list, numChildren-1);
				}
			}
			if (_list.branch.history==null) AppModel.history.getHistoryOfBranch(_list.branch);
		}

		private function onBranchSelected(e:UICommand):void 		{
			this.branch = e.target.branch;
		}

		public function get bookmark():Bookmark
		{
			return _bookmark;
		}
		
		public function get list():HistoryList
		{
			return _list;
		}
		
	}
	
}
