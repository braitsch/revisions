package view.history {
	import events.UIEvent;

	import events.RepositoryEvent;

	import model.Bookmark;

	import flash.display.Sprite;

	public class HistoryCollection extends Sprite {

	// each one of these represent one bookmark in the application //

		private var _bkmk			:Bookmark;
		private var _list			:HistoryList;

		public function HistoryCollection($b:Bookmark)
		{
			_bkmk = $b;
			_bkmk.addEventListener(RepositoryEvent.BRANCH_SET, setActiveBranch);
			
			var a:Array = _bkmk.branches;
			for (var i:int = 0; i < a.length; i++) addChild(new HistoryList(a[i], i));
			
			setActiveBranch();
			addEventListener(UIEvent.HISTORY_TAB_SELECTED, onTabSelected);
		}
		
		public function get list():HistoryList
		{
			return _list;	
		}
		
		public function get bookmark():Bookmark
		{
			return _bkmk;
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
		
		private function setActiveBranch(e:RepositoryEvent = null):void 
		{
		// ignore detached since it is not represented with a tab (collection) //	
			if (_bkmk.branch.name == Bookmark.DETACH) return;
						
			trace("HistoryCollection.setActiveBranch(e) > ", _bkmk.label, _bkmk.branch.name);
			for (var i:int = 0; i < numChildren; i++) {
				if (HistoryList(getChildAt(i)).branch == _bkmk.branch) break;
			}
			setActiveTab(getChildAt(i) as HistoryList);
		}
		
	}
	
}
