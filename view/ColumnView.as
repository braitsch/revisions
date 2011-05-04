package view {

	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
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
					
			addEventListener(UIEvent.DIRECTORY_SELECTED, onDirectorySelection);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, setDirectoryAndFiles);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, clearDirectoriesAndFiles);		}

		public function get columns():Vector.<LiquidColumn>
		{
			return Vector.<LiquidColumn>([_bkmks, _dirs, _files]);		
		}
		
		private function clearDirectoriesAndFiles(e:BookmarkEvent):void
		{
			_dirs.directory = null;
			_files.directory = null;			
		}		
		
		private function setDirectoryAndFiles(e:BookmarkEvent):void
		{
			var f:File = e.data.file as File;
			if (f.isDirectory) {
				_dirs.directory = f;
				_files.directory = f;						
			}	else{
				clearDirectoriesAndFiles(e);
			}
		}
		
		private function onDirectorySelection(e:UIEvent):void 
		{
			_files.directory = ListItem(e.data).file;
		// force a status refresh whenever a directory is selected //
		// this updates the icons next to the files inside the selected directory //	
			AppModel.proxies.status.getStatus();
		}		
		
	}
	
}
