package view.bookmarks {

	import events.RepositoryEvent;
	import model.AppModel;
	import model.Bookmark;
	import view.layout.ListItem;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkListItem extends ListItem {

		private var _view			:BookmarkItemMC = new BookmarkItemMC();
		private var _branches		:Sprite;
		private var _bookmark		:Bookmark;
		
		public function BookmarkListItem($bkmk:Bookmark)
		{
			super.file = $bkmk.file;
			super.draw(190, 20);
			super.active = $bkmk.active;
			
			_bookmark = $bkmk;
			_bookmark.addEventListener(RepositoryEvent.BOOKMARK_EDITED, onBookmarkEdited);
			
			_view.label_txt.autoSize = 'left';
			_view.label_txt.selectable = false;
			_view.label_txt.text = _bookmark.label;
			_view.mouseEnabled = true;
			_view.mouseChildren = false;
			_view.graphics.beginFill(0xff0000, 0);
			_view.graphics.drawRect(0, 0, 190, 20);
			_view.addEventListener(MouseEvent.CLICK, onBookmarkSelection);
			addChild(_view);
			
			if (_bookmark.branches.length > 1) attachBranches();
		}
		
		private function onBookmarkEdited(e:RepositoryEvent):void 		{
			_view.label_txt.text = _bookmark.label;
			super.file = _bookmark.file;
		}
		
		private function attachBranches():void
		{
			_branches = new Sprite();
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

		private function onBranchSelection(e:MouseEvent):void 
		{
		// prevent re-selecting the current branch //	
			if (AppModel.branch == e.target.branch) return;
			if (_bookmark.initialized && _bookmark.branch != e.target.branch){
				AppModel.proxies.checkout.checkoutBranch(_bookmark, e.target.branch);			}	else{				AppModel.engine.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));
			}
		}
		
		private function onBookmarkSelection(e:MouseEvent):void
		{
		// prevent re-selecting the current bookmark //							if (AppModel.bookmark == _bookmark && AppModel.branch.name == 'master') return;
			if (_bookmark.initialized && _bookmark.branch.name != 'master'){
				AppModel.proxies.checkout.checkoutBranch(_bookmark, _bookmark.getBranchByName('master'));
			}	else{				AppModel.engine.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));
			}
		}

	}
	
}
