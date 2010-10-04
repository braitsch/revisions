package view.history {
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
			_list.x = 20;			_list.y = 70;
			_view.addChild(_list);
			super.cancel = _view.close_btn;
			AppModel.history.addEventListener(RepositoryEvent.HISTORY_RECEIVED, onHistoryData);
		}

		private function onHistoryData(e:RepositoryEvent):void 
		{
			while(_list.numChildren) _list.removeChildAt(0);
			for (var i:int = 0; i < e.data.notes.length; i++) {
				var n:HistoryItem = new HistoryItem(i, e.data);
				n.y = 24 * i;
				_list.addChild(n);
			}		
		}
		
	}
	
}
