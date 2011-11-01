package view.history {

	import events.UIEvent;
	import events.AppEvent;
	import model.AppModel;
	import model.vo.Branch;
	import flash.display.Sprite;

	public class HistoryView extends Sprite {

		private static var _branch		:Branch;
		private static var _length		:uint;
		private static var _modified	:Boolean;
		private static var _header		:HistoryHeader = new HistoryHeader();
		private static var _listView	:HistoryList = new HistoryList();
		private static var _mergeView	:MergePreview = new MergePreview();

		public function HistoryView()
		{
			addChildren();
			addEventListener(UIEvent.PAGE_HISTORY, onPageRequest);
			addEventListener(UIEvent.SHOW_MERGE_PREVIEW, onShowMergePreview);
			AppModel.engine.addEventListener(AppEvent.NO_BOOKMARKS, onNoBookmarks);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_DELETED, onNoBookmarks);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RECEIVED, onHistory);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModified);
		}

		private function addChildren():void
		{
			addChild(_listView);
			addChild(_header);
			_listView.y = _mergeView.y = 34;
		}

		public function resize(w:uint, h:uint):void
		{
			_header.resize(w, h); 
			_listView.setSize(w, h - 34);
			_mergeView.setSize(w, h - 34);
		}
		
		private function onHistory(e:AppEvent):void
		{
			if (_branch != AppModel.branch || _modified != AppModel.branch.isModified || _length != AppModel.branch.history.length) {
				_branch = AppModel.branch;
				_modified = AppModel.branch.isModified;
				_length = AppModel.branch.history.length;
				drawView();
			}	else{
				AppModel.dispatch(AppEvent.HISTORY_RENDERED);				
			}
		}		
		
		private function onModified(e:AppEvent):void
		{
			if (AppModel.branch.history == null) return;
			if (AppModel.branch == _branch && AppModel.branch.isModified != _modified) {
				_modified = AppModel.branch.isModified;
				drawView();
			}
		}
		
		private function drawView():void
		{
			_header.refresh();
			_listView.showMostRecent(AppModel.branch);
		}
				
		private function onNoBookmarks(e:AppEvent):void
		{
			_listView.clear();
		}
		
		private function onPageRequest(e:UIEvent):void
		{
			_listView.startFromIndex(AppModel.branch, e.data as uint);	
		}
		
		private function onShowMergePreview(e:UIEvent):void
		{
			addChild(_mergeView);
		}					
		
	}
	
}
