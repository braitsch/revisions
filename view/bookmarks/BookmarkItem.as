package view.bookmarks {
	import view.layout.ListItem;

	public class BookmarkItem extends ListItem {

		private var _bkmk			:Bookmark;
		private var _view			:BookmarkItemMC = new BookmarkItemMC();	
		
		public function BookmarkItem($bkmk:Bookmark)
		{
			super(190, $bkmk.active);
			super.file = $bkmk.file;
			
			_bkmk = $bkmk;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.text = $bkmk.label;
			_view.label_txt.selectable = false;
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			addChild(_view);			
		}
		
		public function get bookmark():Bookmark
		{
			return _bkmk;
		}
	}
}
