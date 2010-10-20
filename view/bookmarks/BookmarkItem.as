package view.bookmarks {
	import events.RepositoryEvent;
	import view.layout.ListItem;

	public class BookmarkItem extends ListItem {

		private var _bkmk			:Bookmark;
		private var _view			:BookmarkItemMC = new BookmarkItemMC();	
		
		public function BookmarkItem($bkmk:Bookmark)
		{
			super(190, $bkmk.active);
			super.file = $bkmk.file;
			
			_bkmk = $bkmk;
			_bkmk.addEventListener(RepositoryEvent.BOOKMARK_EDITED, onBookmarkEdited);
			
			_view.label_txt.autoSize = 'left';
			_view.label_txt.selectable = false;
			_view.label_txt.text = _bkmk.label;
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			
			addChild(_view);
		}

		private function onBookmarkEdited(e:RepositoryEvent):void 
		{			_view.label_txt.text = _bkmk.label;
			super.file = _bkmk.file;
		}

		public function get bookmark():Bookmark
		{
			return _bkmk;
		}
		
	}
	
}
