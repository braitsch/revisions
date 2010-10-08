package view.history {
	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Bookmark;
	import view.modals.ModelWindow;

	import flash.display.Sprite;

	public class HistoryView extends ModelWindow {

		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _container		:Sprite = new Sprite();
		private static var _collection		:HistoryCollection;
		private static var _collections		:Array = [];

		public function HistoryView()
		{
			addChild(_view);
			super.cancel = _view.close_btn;
						_container.x = 20;
			_container.y = 40;
			_view.addChild(_container);

			AppModel.status.addEventListener(RepositoryEvent.STATUS_RECEIVED, onRepositoryStatus);
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady);
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SELECTED, onBookmarkSelected);
		}

		private function onRepositoryStatus(e:RepositoryEvent):void 
		{
			_collection.branch.setRepositoryStatus(e.data);	
		}

		private function onBookmarksReady(e:RepositoryEvent):void 
		{
			for (var i:int = 0;i < e.data.length; i++) {
				_collections.push(new HistoryCollection(e.data[i] as Bookmark));
			}
		}

		private function onBookmarkSelected(e:RepositoryEvent):void 
		{
			while(_container.numChildren) _container.removeChildAt(0);
			for (var i:int = 0; i < _collections.length;i++) {
				if (_collections[i].bookmark==e.data) {
					_collection = _collections[i];
					_container.addChild(_collection);
				}
			}
		}

	}
	
}
