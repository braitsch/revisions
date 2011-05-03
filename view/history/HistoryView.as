package view.history {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
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

			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSet);
			AppModel.engine.addEventListener(BookmarkEvent.BOOKMARKS_LOADED, onBookmarkList);
			AppModel.engine.addEventListener(BookmarkEvent.ADDED, onBookmarkAdded);			AppModel.engine.addEventListener(BookmarkEvent.DELETED, onBookmarkDeleted);
			AppModel.proxies.status.addEventListener(BookmarkEvent.BRANCH_STATUS, onBranchStatus);
		}


	// list editing //

		private function onBookmarkList(e:BookmarkEvent):void 
		{
		// create a collection object for each bookmark we receive //	
			var a:Vector.<Bookmark> = e.data as Vector.<Bookmark>;
			for (var i:int = 0;i < a.length; i++) _collections.push(new HistoryCollection(a[i]));
		}
		
		private function onBookmarkAdded(e:BookmarkEvent):void 
		{
			var k:HistoryCollection = new HistoryCollection(e.data as Bookmark);
			_collections.push(k);
		}	
			
		private function onBookmarkDeleted(e:BookmarkEvent):void 
		{
			while(_container.numChildren) _container.removeChildAt(0);
			for (var i:int = 0;i < _collections.length; i++) {
				if (_collections[i].bookmark == e.data) break;
			}
			_collections[i] = null;
			_collections.splice(i, 1);
		}
		
	// status / selection events //	
		
		private function onBranchStatus(e:BookmarkEvent):void 
		{
		// never refresh the list if the head is detached //	
			if (AppModel.branch.name == Bookmark.DETACH) return;
			if (AppModel.branch.history){
				_collection.list.onStatusRefresh();
			}	else{
				AppModel.proxies.history.getHistoryOfBranch(AppModel.branch);
			}
		}		

		private function onBookmarkSet(e:BookmarkEvent):void 
		{
		// don't change tabs if we've checked out a previous commit (head detached) //	
			if (AppModel.branch.name == Bookmark.DETACH) return;
			
		// display collection associated with the new bookmark //	
			for (var i:int = 0; i < _collections.length; i++) {
				if (_collections[i].bookmark == e.data) break;
			}
			_collection = _collections[i];
			_container.addChild(_collection);
			_collection.setActiveBranch(AppModel.branch);
		}
		
	}
	
}
