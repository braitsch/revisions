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
		private static var _crumbs			:Sprite = new Sprite();
		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _modified		:Boolean = false;

		public function HistoryView()
		{
			addChild(_view);
			super.cancel = _view.close_btn;			_list.x = 20;
			_list.y = 70;
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			_view.addChild(_list);
			_crumbs.x = 110;			_crumbs.y = 18;			_view.addChild(_crumbs);
			AppModel.status.addEventListener(RepositoryEvent.STATUS, onStatus);			AppModel.history.addEventListener(RepositoryEvent.HISTORY_RECEIVED, refreshList);			AppModel.history.addEventListener(RepositoryEvent.HISTORY_UNAVAILABLE, clearList);
			refreshBranches();
		}

		private function onStatus(e:RepositoryEvent):void 
		{
			_modified = e.data[RepositoryStatus.M].length!=0;
		}

		private function refreshBranches():void 
		{
			while(_crumbs.numChildren) _crumbs.removeChildAt(0);
			_crumbs.addChild(new HistoryCrumb('HOME'));
		}

		private function onRecordSelection(e:MouseEvent):void 
		{
			if (_modified){
				trace('local changes exist, checkout aborted');
			}	else{
				trace("HistoryView.onRecordSelection(e)", e.target.sha1);	
			}
		}

		private function clearList(e:RepositoryEvent):void 
		{
			while(_list.numChildren) _list.removeChildAt(0);
		}

		private function refreshList(e:RepositoryEvent):void 
		{
			var v:Vector.<ListItem> = new Vector.<ListItem>();			var h:Array = e.data as Array;
			for (var i:int = 0; i < h.length; i++) {
				v.push(new HistoryItem(h.length-i, h[i]));
			}
			_list.refresh(v);
		}
		
	}
	
}
