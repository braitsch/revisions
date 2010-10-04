package view {
	import commands.UICommand;

	import view.bookmarks.BookmarkView;
	import view.directories.DirectoryView;
	import view.files.FilesView;
	import view.layout.LiquidColumn;
	import view.layout.ListItem;

	import flash.display.Sprite;

	public class ColumnView extends Sprite {

		private static var _files		:FilesView = new FilesView();
		private static var _bookmarks	:BookmarkView = new BookmarkView();
		private static var _directories	:DirectoryView = new DirectoryView();
		
		public function ColumnView()
		{
			this.x = 20;
			this.y = 100;	
			addChild(_bookmarks);
			addChild(_files);
			addChild(_directories);					
			addEventListener(UICommand.DIRECTORY_SELECTED, onDirectorySelection);
		}

		public function get columns():Vector.<LiquidColumn>
		{
			return Vector.<LiquidColumn>([_bookmarks, _directories, _files]);		
		}
		
		private function onDirectorySelection(e:UICommand):void 
		{
			_files.directory = e.data as ListItem;
		}
		
	}
	
}
