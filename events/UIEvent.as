package events {
	import flash.events.Event;

	// events dispatched from user interaction that bubble through the display list //
	public class UIEvent extends Event {
		
	// bookmark and branch commands //	
		public static const BRANCH_SELECTED			:String = "BRANCH_SELECTED";
		public static const BOOKMARK_SELECTED		:String = "BOOKMARK_SELECTED";
		
		public static const ADD_BOOKMARK			:String = "ADD_BOOKMARK";
		public static const EDIT_BOOKMARK			:String = "EDIT_BOOKMARK";
		public static const DELETE_BOOKMARK			:String = "DELETE_BOOKMARK";
		
		public static const EDIT_BRANCH				:String = "EDIT_BRANCH";
		public static const MERGE_BRANCH			:String = "MERGE_BRANCH";
		public static const DELETE_BRANCH			:String = "DELETE_BRANCH";
		
	// modal window events //	
		public static const SAVE_PROJECT			:String = "SAVE_PROJECT";			
		public static const CLOSE_MODAL_WINDOW		:String = "CLOSE_MODAL_WINDOW";
		public static const FILE_BROWSER_SELECTION	:String = "FILE_BROWSER_SELECTION";		
		
	// list item selections //	
		public static const LIST_ITEM_SELECTED		:String = "LIST_ITEM_SELECTED";
		public static const HISTORY_ITEM_SELECTED	:String = "HISTORY_ITEM_SELECTED";
		public static const HISTORY_TAB_SELECTED	:String = "HISTORY_TAB_SELECTED";
		public static const DIRECTORY_SELECTED		:String = "DIRECTORY_SELECTED";
		public static const TOGGLE_OPEN_DIRECTORY	:String = "TOGGLE_OPEN_DIRECTORY";
		
	// layout modifications //	
		public static const COLUMN_RESIZED			:String = "COLUMN_RESIZED";
		
		public var data:Object;

		public function UIEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, true, true);
		}
		
	}
	
}