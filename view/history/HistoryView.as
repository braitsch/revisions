package view.history {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import flash.display.Sprite;

	public class HistoryView extends Sprite {

		private static var _header		:HistoryHeader = new HistoryHeader();
		private static var _activeList	:HistoryList;
		private static var _lists		:Vector.<HistoryList> = new Vector.<HistoryList>();		

		public function HistoryView()
		{
			addChild(_header);
			AppModel.engine.addEventListener(BookmarkEvent.LOADED, onLoaded);
			AppModel.engine.addEventListener(BookmarkEvent.ADDED, onAddition);
			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onDeletion);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelection);
			AppModel.engine.addEventListener(BookmarkEvent.STATUS, onStatus);
			AppModel.engine.addEventListener(BookmarkEvent.HISTORY, onHistory);			
		}
		
		public function resize(w:uint, h:uint):void
		{
			_header.resize(w, h);
		}
		
// list editing //

		private function onLoaded(e:BookmarkEvent):void 
		{
		// create a list object for each bookmark in the database //	
			var a:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			for (var i:int = 0;i < a.length; i++) _lists.push(new HistoryList(a[i]));
		}
		
		private function onAddition(e:BookmarkEvent):void 
		{
			var k:HistoryList = new HistoryList(e.data as Bookmark);
			_lists.push(k);
		}	
			
		private function onDeletion(e:BookmarkEvent):void 
		{
			while(numChildren > 1) removeChildAt(0);
			for (var i:int = 0;i < _lists.length; i++) {
				if (_lists[i].bookmark == e.data) break;
			}
			_lists[i] = null;
			_lists.splice(i, 1);
		}
		
	// status / selection events //	
		
		private function onStatus(e:BookmarkEvent):void 
		{
			_activeList.onStatus();
		}	
	
		private function onHistory(e:BookmarkEvent):void
		{
			_activeList.onHistory();
		}			

		private function onSelection(e:BookmarkEvent):void 
		{
			_activeList = null;
			while(numChildren > 1) removeChildAt(0);
			for (var i:int = 0; i < _lists.length; i++) if (_lists[i].bookmark == e.data) _activeList = _lists[i];
			if (_activeList) {
				_activeList.y = 34;
				addChildAt(_activeList, 0);
			}
		}		
		
	}
	
}
