package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import view.layout.ListItem;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkListItem extends ListItem {

		private var _view			:BookmarkItem = new BookmarkItem();
		private var _branches		:Sprite = new Sprite();
		private var _bookmark		:Bookmark;
		
		public function BookmarkListItem($bkmk:Bookmark)
		{
			super.file = $bkmk.file;
			super.active = $bkmk.active;
			
			_bookmark = $bkmk;
			_bookmark.addEventListener(BookmarkEvent.BRANCH_ADDED, onNewBranchAdded);			
			_bookmark.addEventListener(BookmarkEvent.EDITED, onBookmarkEdited);
			
			_view.label_txt.autoSize = 'left';
			_view.label_txt.selectable = false;
			_view.label_txt.text = _bookmark.label;
			_view.mouseEnabled = true;
			_view.mouseChildren = false;
			_view.blue.alpha = 0;
			_view.addEventListener(MouseEvent.CLICK, onBookmarkSelection);
			addChild(_view);
			
			if (_bookmark.branches.length > 1) attachBranches();
		}

		private function onNewBranchAdded(e:BookmarkEvent):void
		{
			var k:BranchListItem = new BranchListItem(_bookmark.branch);
				k.x = 190;
				k.y = 18 * _branches.numChildren;
			_branches.addChild(k);			
		}
		
		private function onBookmarkEdited(e:BookmarkEvent):void 		{
			_view.label_txt.text = _bookmark.label;
			super.file = _bookmark.file;
		}
		
		private function attachBranches():void
		{
			_branches.y = 22;
			for (var i:int = 1; i < _bookmark.branches.length; i++) {
				var k:BranchListItem = new BranchListItem(_bookmark.branches[i]);
					k.x = 190;
					k.y = 18 * (i - 1);
				_branches.addChild(k);
			}
			addChild(_branches);
			_branches.addEventListener(MouseEvent.CLICK, onBranchSelection);
		}

	//TODO need to check if (bookmark.file.exists == false) prompt for repair

		private function onBranchSelection(e:MouseEvent):void 
		{
		// prevent re-selecting the current branch //	
			if (AppModel.branch == e.target.branch) return;
			if (_bookmark.branch != e.target.branch){
				AppModel.proxies.checkout.bookmark = _bookmark;				AppModel.proxies.checkout.checkout(e.target.branch);			}	else{
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, _bookmark));
			}
		}
		
		private function onBookmarkSelection(e:MouseEvent):void
		{		// prevent re-selecting the current bookmark //				
			if (AppModel.bookmark == _bookmark && AppModel.branch.name == 'master') return;
			if (_bookmark.branch.name != 'master'){				AppModel.proxies.checkout.bookmark = _bookmark;				AppModel.proxies.checkout.checkout(_bookmark.getBranchByName('master'));
			}	else{				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, _bookmark));
			}
		}

	}
	
}
