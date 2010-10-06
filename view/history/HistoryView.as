package view.history {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.RepositoryStatus;

	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.modals.ModelWindow;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryView extends ModelWindow {

		private static var _list			:SimpleList = new SimpleList();
		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _crumbs			:Sprite = new Sprite();

		public function HistoryView()
		{
			addChild(_view);
			super.cancel = _view.close_btn;			_list.x = 20;
			_list.y = 70;
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			_view.addChild(_list);
			_crumbs.x = 110;			_crumbs.y = 18;			_view.addChild(_crumbs);
			
			refreshBranches();
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SELECTED, onBookmarkChange);	
		}

		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			trace("HistoryView.onBookmarkChange(e)", '# items = '+AppModel.bookmark.history.length);
			refresh(AppModel.bookmark.history);
		}

		private function refreshBranches():void 
		{
			while(_crumbs.numChildren) _crumbs.removeChildAt(0);
			_crumbs.addChild(new HistoryCrumb('HOME'));
		}

		private function onRecordSelection(e:MouseEvent):void 
		{
			if (AppModel.bookmark.history[RepositoryStatus.M].length!=0){
				trace('local changes exist, checkout aborted');
			}	else{
				trace("HistoryView.onRecordSelection(e)", e.target.sha1);	
			}
		}

		private function refresh(a:Array):void 
		{
			var v:Vector.<ListItem> = new Vector.<ListItem>();			for (var i:int = 0; i < a.length; i++) {
				v.push(new HistoryItem(a.length-i, a[i]));
			}
			_list.refresh(v);
		}
		
	}
	
}
