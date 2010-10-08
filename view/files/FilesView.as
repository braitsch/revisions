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
		private static var _bmkpath	:String;	// bookmark path //
		private static var _files	:Vector.<ListItem> = new Vector.<ListItem>();

		public function FilesView()
		{
			super.list = _list;
			super.width = 450;
			
			addChild(_view);	
			addChild(_list);	
			
			_list.x = 5;			_list.y = 38;
			_list.contextMenu = AirContextMenu.menu;
			_list.addEventListener(UICommand.LIST_ITEM_SELECTED, onListSelection);					
			
			AppModel.status.addEventListener(RepositoryEvent.STATUS_RECEIVED, onRepositoryStatus);
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SELECTED, onBookmarkChange);
		}
		
		public function set directory(d:ListItem):void
		{
			_files = new Vector.<ListItem>();
			if (d!=null){
				var a:Array = d.file.getDirectoryListing();
				for (var i : int = 0; i < a.length; i++) if (validate(a[i])) _files.push(new FileItem(a[i]));
			}
		// refresh the file view //	
			AppModel.status.getStatus();
		}
		
		private function onBookmarkChange(e:RepositoryEvent):void 
		{
		// show the root contents of the bookmark //	
			_bmkpath = e.data.local;
			directory = e.data as ListItem;
		}

		private function onRepositoryStatus(e:RepositoryEvent):void 
		{
		// we receive the status of everything in the repository //	
			var s:Array = e.data as Array;
			var i:uint;
			file: for (i = 0; i < _files.length; i++) {
				var p:String = _files[i].file.nativePath.replace(_bmkpath+'/', '');
				for (var j:int = 0; j < s.length; j++) {
					for (var k:int = 0; k < s[j].length; k++) {
						if (p==s[j][k]){
							FileItem(_files[i]).status = j;
							continue file;
						}
					}
				}
			}
			super.redrawList(_files);			
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
		//TODO may need to dispatch event here to track the selected file...	
			trace("FilesView.onListSelection(e)", f.file.nativePath);
		}			
		
	}
	
}
