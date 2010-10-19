package view {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;

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
			
			AppModel.engine.addEventListener(RepositoryEvent.NO_BOOKMARKS, clearAllColumns);
		}

		private function clearAllColumns(e:RepositoryEvent):void 
		{
			_bkmks.list.clear();			_dirs.list.clear();			_files.list.clear();
		}

		public function get columns():Vector.<LiquidColumn>
		{
			return Vector.<LiquidColumn>([_bkmks, _dirs, _files]);		
		}
		
		private function onBookmarkSelected(e:UICommand):void 
		{
		// the only place in the application that sets the bookmark //	
			AppModel.bookmark = BookmarkItem(e.data as ListItem).bookmark;
			AppModel.proxies.status.getStatusOfBranch(AppModel.branch);			
			_dirs.directory = e.data as ListItem;
			_files.directory = e.data as ListItem;
		}			
		
		private function onDirectorySelection(e:UICommand):void 
		{
			AppModel.proxies.status.getStatusOfBranch(AppModel.branch);			_files.directory = e.data as ListItem;
		}
		
	}
	
}
