package view.history {
	import events.RepositoryEvent;
	import commands.UICommand;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _bkmk			:Bookmark;
		private var _list			:HistoryList;

		public function HistoryCollection($b:Bookmark)
		{
			_bkmk = $b;
			var a:Array = _bkmk.branches;
			for (var i:int = 0; i < a.length; i++) addChild(new HistoryList(a[i], i));
			
			onBranchChange();
			
			addEventListener(UICommand.HISTORY_TAB_SELECTED, onTabSelected);
			_bkmk.addEventListener(RepositoryEvent.BRANCH_SET, onBranchChange);
		}
		
		public function get bookmark():Bookmark
		{
			return _bkmk;
		}		

		private function set list(l:HistoryList):void
		{
			if (_list) _list.active = false;
			_list = l;
			_list.active = true;
			setChildIndex(_list, numChildren-1);
		}
		
		private function onTabSelected(e:UICommand):void 		{
			this.list = e.target as HistoryList;
		}
		
		private function onBranchChange(e:RepositoryEvent = null):void 
		{
		// trace("HistoryCollection.onBranchChange(e)");
		// automatically highlight the tab associated w/ the new branch	
			for (var i:int = 0; i < numChildren; i++) {
				var k:HistoryList = getChildAt(i) as HistoryList;
				if (k.branch == _bkmk.branch) break;
			}
			this.list = k;
		}		
		
	}
	
}
