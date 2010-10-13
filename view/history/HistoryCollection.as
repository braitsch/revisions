package view.history {
	import commands.UICommand;

	import events.RepositoryEvent;

	import view.bookmarks.Bookmark;

	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _bkmk			:Bookmark;
		private var _list			:HistoryList;

		public function HistoryCollection($b:Bookmark)
		{
			_bkmk = $b;
			_bkmk.addEventListener(RepositoryEvent.BRANCH_SET, onBranchChange);
			
			var a:Array = _bkmk.branches;
			for (var i:int = 0; i < a.length; i++) addChild(new HistoryList(a[i], i));
			
			onBranchChange();
			addEventListener(UICommand.HISTORY_TAB_SELECTED, onTabSelected);
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
		//TODO need to not get this event when working with the detached head	
			trace("HistoryCollection.onBranchChange(e) > ", _bkmk.label, _bkmk.branch.name);
		// automatically highlight the tab associated w/ the new branch	
			for (var i:int = 0; i < numChildren; i++) {
				if (HistoryList(getChildAt(i)).branch ==_bkmk.branch) break;
			}
			this.list = getChildAt(i) as HistoryList;
		}
		
	}
	
}
