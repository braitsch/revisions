package view.directories {
	import commands.UICommand;

	import model.SystemRules;

	import view.layout.LiquidColumn;
	import view.layout.ListItem;
	import view.layout.NestedList;
	import view.ui.AirContextMenu;

	import flash.filesystem.File;

	public class DirectoryView extends LiquidColumn {

		private static var _list		:NestedList = new NestedList();
		private static var _view		:DirectoryViewMC = new DirectoryViewMC();

		public function DirectoryView()
		{
			super.width = 290;			
			
			addChild(_view);
			addChild(_list);
			
			_list.x = 5;
			_list.y = 38;
			_list.scrollbar.x = 278;
			_list.setSize(290, 450);	
			_list.contextMenu = AirContextMenu.menu;
			_list.addEventListener(UICommand.LIST_ITEM_SELECTED, onListSelection);
		}
		
		public function set directory(f:File):void 
		{
			_list.clear();
			if (f == null) return;
			
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			var a:Array = f.getDirectoryListing();
			for (var i : int = 0; i < a.length; i++) if (validate(a[i])) v.push(new Directory(a[i]));
			_list.build(v);
		}		

		private function validate(f:File):Boolean 
		{
			if (f.isDirectory==false) return false;
			if (f.isHidden){
				if (f.nativePath.substr(f.nativePath.lastIndexOf('/')+1)=='.git'){
					if (!SystemRules.SHOW_GIT_REPOSITORY) return false;
				}	else if (!SystemRules.TRACK_HIDDEN_FILES){
					return false;
				}
			}
			return true;
		}
		
		private function onListSelection(e:UICommand):void 
		{
			dispatchEvent(new UICommand(UICommand.DIRECTORY_SELECTED, _list.activeItem as Directory));
		}	
		
	}
	
}
