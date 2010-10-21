package view {
	import events.UIEvent;

	import events.RepositoryEvent;

	import model.AppModel;

	import model.Bookmark;
	import view.bookmarks.BookmarkView;
	import view.directories.DirectoryView;
	import view.files.FilesView;
	import view.layout.LiquidColumn;
	import view.layout.ListItem;

	import flash.display.Sprite;
	import flash.filesystem.File;

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
					
			addEventListener(UIEvent.BOOKMARK_SELECTED, onBookmarkSelected);
			addEventListener(UIEvent.DIRECTORY_SELECTED, onDirectorySelection);
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkSet);		}

		public function get columns():Vector.<LiquidColumn>
		{
			return Vector.<LiquidColumn>([_bkmks, _dirs, _files]);		
		}
		
		private function onBookmarkSet(e:RepositoryEvent):void 
		{
			if (e.data == null){
				clearDirectoryAndFiles();
			}	else{
				setDirectoryAndFiles(e.data.file);
			}
		}
		
		private function onBookmarkSelected(e:UIEvent):void 
		{
			setDirectoryAndFiles(e.data.file);
			setGlobalActiveBookmark(e.data as Bookmark);
		}		
		
		private function onDirectorySelection(e:UIEvent):void 
		{
			_files.directory = ListItem(e.data).file;
			AppModel.proxies.status.getStatusOfBranch(AppModel.branch);		}
		
		private function setDirectoryAndFiles(f:File):void
		{
			_dirs.directory = f;
			_files.directory = f;						
		}
		
		private function clearDirectoryAndFiles():void
		{
			_dirs.directory = null;
			_files.directory = null;			
		}		
		
	// -- once dispatched this updates everything in the application -- //	
		private function setGlobalActiveBookmark(n:Bookmark):void
		{
			AppModel.engine.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, n));			
		}
		
	}
	
}
