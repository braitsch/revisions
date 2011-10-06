package view.history {

	import events.AppEvent;
	import events.BookmarkEvent;
	import model.AppModel;
	import flash.display.Sprite;

	public class HistoryView extends Sprite {

		private static var _list		:HistoryList = new HistoryList();
		private static var _header		:HistoryHeader = new HistoryHeader();

		public function HistoryView()
		{
			_list.y = 34;
			addChild(_list);
			addChild(_header);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelected);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RECEIVED, onHistory);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModified);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, onNoBookmarks);
		}

		public function resize(w:uint, h:uint):void
		{
			_header.resize(w, h); _list.setSize(w, h - _list.y);
		}
		
		private function onSelected(e:BookmarkEvent):void 
		{
			AppModel.bookmark.branch.history ? drawView() : clearView();
		}
		
		private function onModified(e:AppEvent):void
		{
			AppModel.bookmark.branch.history ? drawView() : clearView();
		}									
		
		private function onHistory(e:AppEvent):void
		{
			drawView();
		}		
		
		private function onNoBookmarks(e:BookmarkEvent):void
		{
			clearView();
		}
		
		private function drawView():void
		{
			_header.refresh();
			_list.bookmark = AppModel.bookmark;
		}
		
		private function clearView():void
		{
			_header.clear();
			_list.bookmark = null;
		}
		
	}
	
}
