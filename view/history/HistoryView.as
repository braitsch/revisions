package view.history {
	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Bookmark;
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

			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkSet);
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_LIST, onBookmarkList);
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_ADDED, onBookmarkAdded);			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_DELETED, onBookmarkDeleted);			AppModel.proxies.status.addEventListener(RepositoryEvent.BRANCH_STATUS, onBranchStatus);
		}

	// list editing //

		private function onBookmarkList(e:RepositoryEvent):void 
		{
			trace("HistoryView.onBookmarkList(e)");
		// create a collection object for each bookmark we receive //	
			var a:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			for (var i:int = 0;i < a.length; i++) _collections.push(new HistoryCollection(a[i]));
		}
		
		private function onBookmarkAdded(e:RepositoryEvent):void 
		{
			trace("HistoryView.onBookmarkAdded(e)");
			var k:HistoryCollection = new HistoryCollection(e.data as Bookmark);
			_collections.push(k);
		}	
			
		private function onBookmarkDeleted(e:RepositoryEvent):void 
		{
			for (var i:int = 0;i < _collections.length; i++) {
				var k:HistoryCollection = _collections[i];
				if (k.bookmark == e.data) {
					_collections.splice(i, 1);
					k = null;
				}
			}
		}
		
	// status / selection events //	
		
		private function onBranchStatus(e:RepositoryEvent):void 
		{
			trace("HistoryView.onBranchStatus(e)");
		// never refresh the list if the head is detached //	
			if (AppModel.branch.name == Bookmark.DETACH) return;
			_collection.list.onStatusRefresh();
		}		

		private function onBookmarkSet(e:RepositoryEvent):void 
		{
			trace("HistoryView.onBookmarkSet(e)");
		// set the active collection object //	
			for (var i:int = 0; i < _collections.length; i++) {
				var k:HistoryCollection = _collections[i];
				if (k.bookmark == e.data) this.collection = k;
			}
		}
		
		private function set collection(k:HistoryCollection):void
		{
			_collection = k;
			while(_container.numChildren) _container.removeChildAt(0);
			_container.addChild(_collection);
		}
		
	}
	
}
