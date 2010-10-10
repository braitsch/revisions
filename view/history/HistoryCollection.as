package view.history {
	import commands.UICommand;

	import view.bookmarks.Bookmark;

	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _bookmark		:Bookmark;
		private var _list			:HistoryList;

		public function HistoryCollection($b:Bookmark)
		{
			_bookmark = $b;
			for (var i:int = 0; i < _bookmark.branches.length; i++) {
				var list:HistoryList = new HistoryList(_bookmark.branches[i], i);
				if (_bookmark.branches[i]==_bookmark.branch) _list = list;
				addChild(list);
			}
			_list.active = true;
			addEventListener(UICommand.BRANCH_SELECTED, onBranchSelected);
		}

		private function onBranchSelected(e:UICommand):void 
		{
			_list.active = false;			_list = e.target as HistoryList;
			_list.active = true;
			_list.onStatusReceived();
			setChildIndex(_list, numChildren-1);
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
