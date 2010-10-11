package view.history {
	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Bookmark;
	import view.layout.ListItem;
	import view.modals.ModalWindow;

	import flash.display.Sprite;

	public class HistoryView extends ModalWindow {

		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _container		:Sprite = new Sprite();
		private static var _collection		:HistoryCollection;
		private static var _collections		:Vector.<HistoryCollection> = new Vector.<HistoryCollection>();

		public function HistoryView()
		{
			addChild(_view);
			super.height = 450;
			super.cancel = _view.close_btn;
						_container.x = 20;
			_container.y = 40;
			_view.addChild(_container);

			AppModel.branch.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady, false, 2);
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SELECTED, onBookmarkSelected);
		}

		private function onBookmarksReady(e:RepositoryEvent):void 
		{
		// create a collection object for each bookmark //	
			var a:Vector.<ListItem> = AppModel.bookmarks;
			for (var i:int = 0;i < a.length; i++) {
				_collections.push(new HistoryCollection(a[i] as Bookmark));
			}
		}

		private function onBookmarkSelected(e:RepositoryEvent):void 
		{
		// set the active collection object //	
			while(_container.numChildren) _container.removeChildAt(0);
			for (var i:int = 0; i < _collections.length;i++) {
				var k:HistoryCollection = _collections[i];
				if (k.bookmark == e.data) _collection = k;
			}
			_container.addChild(_collection);
		// should be set from dispatched branch-selected event //	
			_collection.branch = _collection.bookmark.branch;
		}

	}
	
}
