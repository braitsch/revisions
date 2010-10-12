package commands {
	import flash.events.Event;

	// events dispatched from user interaction that bubble through the display list //
	public class UICommand extends Event {
		
	// modal window events //	
		public static const INSTALL_GIT:String = "INSTALL_GIT";
		public static const CLOSE_MODAL_WINDOW:String = "CLOSE_MODAL_WINDOW";
		public static const FILE_BROWSER_SELECTION:String = "FILE_BROWSER_SELECTION";
		
		public static const NEW_BOOKMARK:String = "NEW_BOOKMARK";
		public static const EDIT_BOOKMARK:String = "EDIT_BOOKMARK";
		public static const REPAIR_BOOKMARK:String = "REPAIR_BOOKMARK";		public static const DELETE_BOOKMARK:String = "DELETE_BOOKMARK";
		
		public static const ADD_BRANCH:String = "ADD_BRANCH";
		public static const DELETE_BRANCH:String = "DELETE_BRANCH";
		public static const CHANGE_BRANCH:String = "CHANGE_BRANCH";
		public static const MERGE_BRANCH:String = "MERGE_BRANCH";
		public static const DETACHED_BRANCH_EDITED:String = "DETACHED_BRANCH_EDITED";
		
		public static const SAVE_PROJECT:String = "SAVE_PROJECT";			
		public static const VIEW_HISTORY:String = "VIEW_HISTORY";		public static const VIEW_VERSION:String = "VIEW_VERSION";
		
	// list item selections //	
		public static const LIST_ITEM_SELECTED:String = "LIST_ITEM_SELECTED";
		public static const HISTORY_ITEM_SELECTED:String = "HISTORY_ITEM_SELECTED";
		public static const BOOKMARK_SELECTED:String = "BOOKMARK_SELECTED";
		public static const HISTORY_TAB_SELECTED:String = "BRANCH_SELECTED";
		public static const DIRECTORY_SELECTED:String = "DIRECTORY_SELECTED";
		public static const TOGGLE_OPEN_DIRECTORY:String = "TOGGLE_OPEN_DIRECTORY";
		
		public static const COLUMN_RESIZED:String = "COLUMN_RESIZED";
		public var data:Object;

		public function UICommand($type:String, $data:Object = null)
		{
			data = $data;
			super($type, true, true);
		}
		
	}
	
}
