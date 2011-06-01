package view.history {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryView extends Sprite {

		private static var _mask		:Shape = new Shape();
		private static var _header		:HistoryHeader = new HistoryHeader();
		private static var _activeList	:HistoryList;
		private static var _lists		:Vector.<HistoryList> = new Vector.<HistoryList>();
		private static var _listYpos	:uint = 34;
		private static var _mainHeight	:uint;

		public function HistoryView()
		{
			addChild(_mask);
			addChild(_header);
			_mask.y = _listYpos;
			AppModel.engine.addEventListener(BookmarkEvent.LOADED, onLoaded);
			AppModel.engine.addEventListener(BookmarkEvent.ADDED, onAddition);
			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onDeletion);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelection);
			AppModel.engine.addEventListener(BookmarkEvent.STATUS, onStatus);
			AppModel.engine.addEventListener(BookmarkEvent.HISTORY, onHistory);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);			
		}

		private function onMouseWheel(e:MouseEvent):void
		{
			if (_activeList.height <= _mainHeight) return;
			_activeList.y += e.delta;
			var minY:int = _listYpos - _activeList.height + _mainHeight;
			if (_activeList.y >= _listYpos) {
				_activeList.y = _listYpos;
			}	else if (_activeList.y < minY){
				_activeList.y = minY;
			}
//			TweenLite.to(_activeList, .3, {y:_activeList.y+(e.delta*2)});
		}
		
		public function resize(w:uint, h:uint):void
		{
			_header.resize(w, h);
			_mainHeight = h-_listYpos;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000, 0);
			_mask.graphics.drawRect(0, 0, w, h-_listYpos);
			_mask.graphics.endFill();
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
			while(numChildren > 2) removeChildAt(0);
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
			while(numChildren > 2) removeChildAt(0);
			for (var i:int = 0; i < _lists.length; i++) if (_lists[i].bookmark == e.data) _activeList = _lists[i];
			if (_activeList) {
				_activeList.y = _listYpos;
				addChildAt(_activeList, 0);
			}
		}		
		
	}
	
}
