package view.history {
	import flash.events.MouseEvent;
	import view.bookmarks.Bookmark;

	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _bookmark		:Bookmark;
		private var _branch			:HistoryList;

		public function HistoryCollection($b:Bookmark)
		{
			_bookmark = $b;
			for (var i:int = 0; i < _bookmark.branches.length; i++) {
				var list:HistoryList = new HistoryList(_bookmark.branches[i], i);
				if (_bookmark.branches[i]==_bookmark.branch) _branch = list;
				addChild(list);
			}
			addEventListener(MouseEvent.CLICK, onListSelection);
		}

		private function onListSelection(e:MouseEvent):void 
		{
			trace("HistoryCollection.onListSelection(e)", e.target);
			// tab to selected list..
		}

		public function get bookmark():Bookmark
		{
			return _bookmark;
		}
		
		public function get branch():HistoryList
		{
			return _branch;
		}
		
	}
	
}
