package view.ui {

	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import view.bookmarks.BookmarkListItem;
	import view.layout.ListItem;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class AirContextMenu {
		
		private static var _menu		:ContextMenu = new ContextMenu();
		private static var _stage		:Stage;
		private static var _fileOptions :Array = [	new ContextMenuItem('Track Item'),
													new ContextMenuItem('UnTrack Item'),													new ContextMenuItem('Mark As Ignored')];
															private static var _bkmkOptions	:Array = [	new ContextMenuItem('Save Latest Version'),
													new ContextMenuItem('Delete Bookmark'),
													new ContextMenuItem('Show Bookmark Details'),
													new ContextMenuItem('Edit Bookmark Settings')];
		
		static public function initialize(s:Stage):void
		{
			_stage = s;
			for (var i : int = 0;i < _fileOptions.length; i++){
				_fileOptions[i].addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFileContextClick);
			}
			
			for (var j : int = 0;j < _bkmkOptions.length; j++){
				_bkmkOptions[j].addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onBookmarkContextClick);
			}			
			
			_menu.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenuClick);				
		}

		static public function get menu():ContextMenu { return _menu; }

		static private function onContextMenuClick(e:ContextMenuEvent):void 
		{
			if (e.mouseTarget is BookmarkItem){
				var b:Bookmark = getBookmark(e.mouseTarget);
				_bkmkOptions[0].enabled = b.branch.modified;
				_menu.customItems = _bkmkOptions;			}	else{
				_menu.customItems = _fileOptions;
			}
		}

		static private function onFileContextClick(e:ContextMenuEvent):void 
		{
			var cmi:ContextMenuItem = e.target as ContextMenuItem;
			switch(cmi.label){
				case 'Track Item' : 
					AppModel.proxies.editor.trackFile(getFileItem(e.mouseTarget).file);		
				break;
				case 'UnTrack Item' : 
					AppModel.proxies.editor.unTrackFile(getFileItem(e.mouseTarget).file);
				break;				
			}
		}
		
		static private function onBookmarkContextClick(e:ContextMenuEvent):void 
		{
			var bkmk:Bookmark = getBookmark(e.mouseTarget);
			var cmi:ContextMenuItem = e.target as ContextMenuItem;
			switch(cmi.label){
				case 'Save Latest Version' : 
					_stage.dispatchEvent(new UIEvent(UIEvent.COMMIT, bkmk));	
					AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, bkmk));	
				break;				case 'Edit Bookmark Settings' : 
					_stage.dispatchEvent(new UIEvent(UIEvent.EDIT_BOOKMARK, bkmk));	
				break;				case 'Delete Bookmark' : 
					_stage.dispatchEvent(new UIEvent(UIEvent.DELETE_BOOKMARK, bkmk));	
				break;
				case 'Show Bookmark Details' : 
					AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, bkmk));	
				break;				
			}
		}
		
		private static function getBookmark(o:InteractiveObject):Bookmark 
		{
			while(o.parent){
				if (o is BookmarkListItem) break;
				o = o.parent;
			}
			return BookmarkListItem(o).bookmark;
		}
		
		static private function getFileItem(o:DisplayObject):ListItem
		{
			while(o.parent){
				if (o is ListItem) break;			
				o = o.parent;
			}
			return o as ListItem;
		}
		
	}
}
