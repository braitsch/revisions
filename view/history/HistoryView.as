package view.history {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.RepositoryStatus;

	import view.bookmarks.Bookmark;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.modals.ModelWindow;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryView extends ModelWindow {

		private static var _list			:SimpleList = new SimpleList();
		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _crumbs			:Sprite = new Sprite();
		private static var _modified		:Boolean = false;

		public function HistoryView()
		{
			addChild(_view);
			super.cancel = _view.close_btn;			_list.x = 20;
			_list.y = 70;
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			_view.addChild(_list);
			_crumbs.x = 110;			_crumbs.y = 18;			_view.addChild(_crumbs);
			_crumbs.buttonMode = true;			_crumbs.addEventListener(MouseEvent.CLICK, onCrumbSelection);
			
			refreshBranches();
			
			AppModel.status.addEventListener(RepositoryEvent.STATUS_RECEIVED, onRepositoryStatus);			AppModel.history.addEventListener(RepositoryEvent.HISTORY_RECEIVED, onRepositoryHistory);
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SELECTED, onBookmarkChange);	
		}

		private function onRepositoryStatus(e:RepositoryEvent):void 
		{
			_modified = e.data[RepositoryStatus.M].length!=0;
		}
		
		private function onRepositoryHistory(e:RepositoryEvent):void 
		{
			refreshHistory(e.data as Array);
		}		

		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			var a:Array = Bookmark(e.data).history;			if (a) refreshHistory(a);
		}
		
		private function refreshHistory(a:Array):void
		{
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			for (var i:int = 0; i < a.length; i++) {
				v.push(new HistoryItem(a.length-i, a[i]));
			}
			_list.refresh(v);			
			trace("HistoryView.onBookmarkChange(e)", '# items = '+a.length);			
		}

		private function refreshBranches():void 
		{
		//	while(_crumbs.numChildren) _crumbs.removeChildAt(0);
			_crumbs.addChild(new HistoryCrumb('HOME'));
		}

		private function onRecordSelection(e:MouseEvent):void 
		{
			trace(e.target.sha1, _modified);
			AppModel.history.checkoutCommit(e.target.sha1, _modified);		}
		
		private function onCrumbSelection(e:MouseEvent):void 
		{
			if (e.target.name=='HOME'){
				AppModel.history.checkoutMaster();
			}
		}		

	}
	
}
