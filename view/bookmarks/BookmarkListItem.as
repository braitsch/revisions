package view.bookmarks {
	import model.Bookmark;

	import events.UIEvent;

	import events.RepositoryEvent;

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

		public function get bookmark():Bookmark
		{
			return _bookmark;
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

		private function onBookmarkSelection(e:MouseEvent):void 
		{
			_bookmark.branch = _bookmark.getBranchByName('master');
			dispatchEvent(new UIEvent(UIEvent.BOOKMARK_SELECTED, _bookmark));		}
				
		private function onBranchSelection(e:MouseEvent):void 
		{
			_bookmark.branch = e.target.branch;
			dispatchEvent(new UIEvent(UIEvent.BOOKMARK_SELECTED, _bookmark));
		}

	}
	
}
