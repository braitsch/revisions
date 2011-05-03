package view.files {
	import events.BookmarkEvent;
	import events.UIEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.SystemRules;
	import view.layout.LiquidColumn;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.ui.AirContextMenu;

	public class FilesView extends LiquidColumn {

		private static var _list	:SimpleList = new SimpleList();
		private static var _view	:FilesViewMC = new FilesViewMC();
		private static var _files	:Vector.<ListItem> = new Vector.<ListItem>();

		public function FilesView()
		{
			super.width = 450;
						
			_list.x = 5;			_list.y = 38;
			_list.setSize(450, 450);
			_list.scrollbar.x = 438;
			_list.contextMenu = AirContextMenu.menu;
			_list.addEventListener(UIEvent.LIST_ITEM_SELECTED, onListSelection);					
			
			addChild(_view);
			addChild(_list);
			
			AppModel.proxies.status.addEventListener(BookmarkEvent.BRANCH_STATUS, onStatusReceived);
		}
		
		public function set directory(f:File):void
		{
			_list.clear();
			if (f == null) return;
			
			_files = new Vector.<ListItem>();
			var a:Array = f.getDirectoryListing();
			for (var i : int = 0; i < a.length; i++) if (validate(a[i])) _files.push(new FileListItem(a[i]));
		}

		private function onStatusReceived(e:BookmarkEvent):void 
		{
		// we receive the full status of the active branch //	
			var a:Array = e.data as Array;
			file: for (var i:int = 0; i < _files.length; i++) {
				var p:String = _files[i].file.name;
				for (var j:int = 0; j < a.length; j++) {
					for (var k:int = 0; k < a[j].length; k++) {
						var n:String = a[j][k].substring(a[j][k].lastIndexOf('/')+1);
						if (p == n){
							FileListItem(_files[i]).status = j;
							continue file;
						}
					}
				}
			}
			_list.clear();			
			_list.build(_files);
		}		

		private function validate(f:File):Boolean 
		{
			if (f.isDirectory) return false;
			if (f.isHidden && !SystemRules.TRACK_HIDDEN_FILES) return false;
			for (var i : int = 0; i < SystemRules.FORBIDDEN_FILES.length; i++) {
				if (f.url.indexOf(SystemRules.FORBIDDEN_FILES[i])!=-1) return false;
			}
			return true;
		}
		
		private function onListSelection(e:UIEvent):void 
		{
			var f:FileListItem = _list.activeItem as FileListItem;
			trace("FilesView.onListSelection(e)", f.file.nativePath);
		}			
		
	}
	
}
