package view.history {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Bookmark;
	import view.layout.ListItem;
	import view.modals.ModalWindow;

	import flash.display.Sprite;

	public class HistoryView extends ModalWindow {

		private static var _view			:HistoryViewMC = new HistoryViewMC();
		private static var _selectedItem	:HistoryItem;
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

			addEventListener(UICommand.HISTORY_ITEM_SELECTED, onHistoryItemSelection);
			
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkSelected);
			AppModel.status.addEventListener(RepositoryEvent.BRANCH_MODIFIED, onModifiedReceived);
			AppModel.branch.addEventListener(RepositoryEvent.BOOKMARKS_READY, onBookmarksReady, false, 2);
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
		}
		
	// checkouts //	
	
		private function onHistoryItemSelection(e:UICommand):void 
		{
			trace('------------------------------');
			_selectedItem = e.data as HistoryItem;
		// always force refresh the status of the current branch before attempting a checkout	
			AppModel.status.getActiveBranchIsModified();			
		}	
		
		private function onModifiedReceived(e:RepositoryEvent):void 
		{
			trace("HistoryView.onModified(e) > active branch modified = ", e.data);
			if (AppModel.bookmark.branch.name==Bookmark.DETACH && e.data == true){
				trace('local modifications on the detached branch');
			//	stage.dispatchEvent(new UICommand(UICommand.DETACHED_BRANCH_EDITED));				
			}	else if (_selectedItem.index == 0){
				trace('no local changes - checking out master');			//	AppModel.history.checkoutMaster();
			}	else{
				trace('no local changes - checking out commit > ', _selectedItem.sha1);
			//	AppModel.history.checkoutCommit(_selectedItem.sha1);
			}
		}		

	}
	
}
