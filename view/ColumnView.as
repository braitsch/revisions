package view {
	import commands.UICommand;

	import model.AppModel;

	import view.bookmarks.Bookmark;
	import view.bookmarks.BookmarkItem;
	import view.bookmarks.BookmarkView;
	import view.directories.DirectoryView;
	import view.files.FilesView;
	import view.layout.LiquidColumn;
	import view.layout.ListItem;

	import flash.display.Sprite;

	public class ColumnView extends Sprite {

		private static var _bkmks	:BookmarkView = new BookmarkView();
		private static var _dirs	:DirectoryView = new DirectoryView();
		private static var _files	:FilesView = new FilesView();
		
		public function ColumnView()
		{
			this.x = 20;
			this.y = 100;	
			
			addChild(_bkmks);
			addChild(_dirs);			
			addChild(_files);
					
			addEventListener(UICommand.BOOKMARK_SELECTED, onBookmarkSelected);
			addEventListener(UICommand.DIRECTORY_SELECTED, onDirectorySelection);
		}

		public function get columns():Vector.<LiquidColumn>
		{
			return Vector.<LiquidColumn>([_bkmks, _dirs, _files]);		
		}
		
		private function onBookmarkSelected(e:UICommand):void 
		{
			var b:Bookmark = BookmarkItem(e.data as ListItem).bookmark;
			AppModel.repos.bookmark = b;
			AppModel.repos.bookmark.branch.getStatus();
			
			_dirs.directory = e.data as ListItem;
			_files.directory = e.data as ListItem;
		}			
		
		private function onDirectorySelection(e:UICommand):void 
		{
			AppModel.repos.bookmark.branch.getStatus();			_files.directory = e.data as ListItem;
		}
		
	}
	
}
