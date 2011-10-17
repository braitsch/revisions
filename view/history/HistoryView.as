package view.history {

	import events.UIEvent;
	import events.AppEvent;
	import model.AppModel;
	import model.vo.Branch;
	import flash.display.Sprite;

	public class HistoryView extends Sprite {

		private static var _branch		:Branch;
		private static var _modified	:Boolean;
		private static var _list		:HistoryList = new HistoryList();
		private static var _header		:HistoryHeader = new HistoryHeader();

		public function HistoryView()
		{
			_list.y = 34;
			addChild(_list);
			addChild(_header);
			addEventListener(UIEvent.PAGE_HISTORY, onPageRequest);
			AppModel.engine.addEventListener(AppEvent.NO_BOOKMARKS, onNoBookmarks);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_DELETED, onNoBookmarks);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RECEIVED, onHistory);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModified);
			AppModel.engine.addEventListener(AppEvent.BRANCH_CHANGED, onBranchChanged);
		}

		public function resize(w:uint, h:uint):void
		{
			_header.resize(w, h); _list.setSize(w, h - _list.y);
		}
		
		private function onHistory(e:AppEvent):void
		{
			trace("HistoryView.onHistory(e)");
			drawView();
			_branch = AppModel.branch;
		}		
		
		private function onModified(e:AppEvent):void
		{
			trace("HistoryView.onModified(e)");
			if (AppModel.branch.history) checkIfChanged();
		}	
		
		private function onBranchChanged(e:AppEvent):void
		{
			_branch = AppModel.branch;
		}										

		private function drawView():void
		{
			_header.refresh();
			_list.showMostRecent();
		}
				
		private function onNoBookmarks(e:AppEvent):void
		{
			_header.clear();
			_list.killHistory();
		}
		
		private function checkIfChanged():void
		{
			if (_branch == AppModel.branch && _modified != AppModel.branch.isModified) {
				drawView();
				_modified = AppModel.branch.isModified;
			}
		}
		
		private function onPageRequest(e:UIEvent):void
		{
			_list.showFromIndex(e.data as uint);	
		}				
		
	}
	
}
