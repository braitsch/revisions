package view.ui {

	import events.UIEvent;
	import model.AppModel;
	import view.layout.ListItem;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class AirContextMenu {
		
		private static var _menu		:ContextMenu = new ContextMenu();
		private static var _stage		:Stage;
		private static var _fileOptions :Array = [	new ContextMenuItem('Track Item'),
													new ContextMenuItem('UnTrack Item'),													new ContextMenuItem('Mark As Ignored')];
															private static var _bkmkOptions	:Array = [	new ContextMenuItem('Save Version'),
													new ContextMenuItem('Edit Bookmark'),													new ContextMenuItem('Delete Bookmark')];
		
		static public function initialize(s:Stage):void
		{
			_stage = s;
			for (var i : int = 0;i < _fileOptions.length; i++){
				_fileOptions[i].addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelect);
			}
			
			for (var j : int = 0;j < _bkmkOptions.length; j++){
				_bkmkOptions[j].addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelect);
			}			
			
			_menu.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenuClick);				
						
		}

		static public function get menu():ContextMenu
		{
			return _menu;
		}

		static private function onContextMenuClick(e:ContextMenuEvent):void 
		{
			if (e.mouseTarget is BookmarkItem){
				_menu.customItems = _bkmkOptions;			}	else{
				_menu.customItems = _fileOptions;
			}
		}
		
		static private function onContextMenuItemSelect(e:ContextMenuEvent):void 
		{
			var cmi:ContextMenuItem = e.target as ContextMenuItem;
			switch(cmi.label){
				case 'Save Version' : 
					_stage.dispatchEvent(new UIEvent(UIEvent.SAVE_PROJECT));	break;				case 'Edit Bookmark' : 
					_stage.dispatchEvent(new UIEvent(UIEvent.EDIT_BOOKMARK));	break;				case 'Delete Bookmark' : 
					_stage.dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK));	break;
				case 'Track Item' : 
					AppModel.proxies.editor.trackFile(getListItem(e.mouseTarget).file);		break;				case 'UnTrack Item' : 
					AppModel.proxies.editor.unTrackFile(getListItem(e.mouseTarget).file);	break;
			}
			trace("AirContextMenu.onContextMenuItemSelect(e)", e.mouseTarget, cmi.label);
		}
		
		static private function getListItem(k:DisplayObject):ListItem
		{
			while(k.parent){
				if (k is ListItem) break;			
				k = k.parent;
			}
			return k as ListItem;
		}
		
	}
}
