package view.history {

	import events.RepositoryEvent;
	import events.UIEvent;
	import model.Bookmark;
	import model.Branch;
	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _list				:HistoryList;
		private var _bookmark			:Bookmark;

		public function HistoryCollection($b:Bookmark)
		{
			_bookmark = $b;
			_bookmark.addEventListener(RepositoryEvent.BRANCH_ADDED, onNewBranchAdded);
			
			var a:Array = _bookmark.branches;
			for (var i:int = 0; i < a.length; i++) addChild(new HistoryList(a[i], i));
			
			setActiveBranch(_bookmark.branch);
			addEventListener(UIEvent.HISTORY_TAB_SELECTED, onTabSelected);
		}
	
	// public //	
		
		public function get list():HistoryList
		{
			return _list;	
		}
		
		public function get bookmark():Bookmark
		{
			return _bookmark;
		}
		
		public function setActiveBranch(b:Branch):void
		{
			if (b.name == Bookmark.DETACH) b = _bookmark.getBranchByName('master');
			for (var i:int = 0; i < numChildren; i++) if (HistoryList(getChildAt(i)).branch == b) break;
			setActiveTab(getChildAt(i) as HistoryList);			
		}
		
	// private //	

		private function setActiveTab(k:HistoryList):void
		{
			if (_list) _list.active = false;
			_list = k;
			_list.active = true;
			setChildIndex(_list, numChildren-1);
		}
		
		private function onTabSelected(e:UIEvent):void 		{
			setActiveTab(e.target as HistoryList);
		}
		
		private function onNewBranchAdded(e:RepositoryEvent):void
		{
			trace("HistoryCollection.onNewBranchAdded(e) >> ", _bookmark.branch.name);
			var k:HistoryList = new HistoryList(_bookmark.branch, numChildren);
			addChild(k);
			setActiveTab(k);			
		}		
		
	}
	
}
