package view.files {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;
	import model.SystemRules;

	import view.layout.LiquidColumn;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.ui.AirContextMenu;

	import flash.filesystem.File;

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
			_list.addEventListener(UICommand.LIST_ITEM_SELECTED, onListSelection);					
			
			addChild(_view);
			addChild(_list);
			
			AppModel.proxies.status.addEventListener(RepositoryEvent.BRANCH_STATUS, onStatusReceived);
		}
		
		public function get list():SimpleList
		{
			return _list;
		}			
		
		public function set directory(d:ListItem):void
		{
			_files = new Vector.<ListItem>();
			if (d != null){
				var a:Array = d.file.getDirectoryListing();
				for (var i : int = 0; i < a.length; i++) if (validate(a[i])) _files.push(new FileItem(a[i]));
			}
		}

		private function onStatusReceived(e:RepositoryEvent):void 
		{
		// we receive the full status of the active branch //	
			var a:Array = e.data as Array;
			file: for (var i:int = 0; i < _files.length; i++) {
		// slice off the root path of the bookmark since git returns an abbreviated path //
				var p:String = _files[i].file.nativePath.replace(AppModel.bookmark.local+'/', '');
				for (var j:int = 0; j < a.length; j++) {
					for (var k:int = 0; k < a[j].length; k++) {
						if (p == a[j][k]){
							FileItem(_files[i]).status = j;
							continue file;
						}
					}
				}
			}
			_list.refresh(_files);
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
		
		private function onListSelection(e:UICommand):void 
		{
			var f:FileItem = _list.activeItem as FileItem;
			trace("FilesView.onListSelection(e)", f.file.nativePath);
		}			
		
	}
	
}
