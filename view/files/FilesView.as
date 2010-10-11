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
			
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkChange);
		}
		
		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			AppModel.bookmark.branch.addEventListener(RepositoryEvent.BRANCH_STATUS, onRepositoryStatus);
		}

		public function set directory(d:ListItem):void
		{
			_files = new Vector.<ListItem>();
			if (d!=null){
				var a:Array = d.file.getDirectoryListing();
				for (var i : int = 0; i < a.length; i++) if (validate(a[i])) _files.push(new FileItem(a[i]));
			}
		}

		private function onRepositoryStatus(e:RepositoryEvent):void 
		{
			var i:int;
			var s:Array = AppModel.bookmark.branch.status;
			file: for (i = 0; i < _files.length; i++) {
		// slice off the root path of the bookmark since git returns an abbreviated path //
				var p:String = _files[i].file.nativePath.replace(AppModel.bookmark.local+'/', '');
				for (var j:int = 0; j < s.length; j++) {
					for (var k:int = 0; k < s[j].length; k++) {
						if (p==s[j][k]){
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
