package view.history {
	import flash.events.MouseEvent;
	import events.RepositoryEvent;

	import model.AppModel;

	import view.modals.ModelWindow;

	import flash.display.Sprite;

	public class HistoryView extends ModelWindow {

		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _list			:Sprite = new Sprite();

		public function HistoryView()
		{
			addChild(_view);
			super.cancel = _view.close_btn;			_list.x = 20;
			_list.y = 70;
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			_view.addChild(_list);
			AppModel.history.addEventListener(RepositoryEvent.HISTORY_RECEIVED, refreshList);			AppModel.history.addEventListener(RepositoryEvent.HISTORY_UNAVAILABLE, clearList);
		}

		private function onRecordSelection(e:MouseEvent):void 
		{
			trace("HistoryView.onRecordSelection(e)", e.target.sha1);	
		}

		private function clearList(e:RepositoryEvent):void 
		{
			while(_list.numChildren) _list.removeChildAt(0);
		}

		private function refreshList(e:RepositoryEvent):void 
		{			while(_list.numChildren) _list.removeChildAt(0);
			var h:Array = e.data as Array;
			for (var i:int = 0; i < h.length; i++) {
				var n:HistoryItem = new HistoryItem(h.length-i, h[i]);
				n.y = 24 * i;
				_list.addChild(n);
			}		
		}
		
	}
	
}
