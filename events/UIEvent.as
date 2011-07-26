package events {
	import flash.events.Event;

	// events dispatched from user interaction that bubble through the display list //
	public class UIEvent extends Event {
		
	// bookmark and branch commands //	
		public static const ADD_BOOKMARK			:String = "ADD_BOOKMARK";
		public static const EDIT_BOOKMARK			:String = "EDIT_BOOKMARK";		public static const REPAIR_BOOKMARK			:String = "REPAIR_BOOKMARK";
		public static const DELETE_BOOKMARK			:String = "DELETE_BOOKMARK";
				public static const CLONE					:String = "CLONE";		public static const COMMIT					:String = "COMMIT";
		public static const REVERT					:String = "REVERT";
		public static const DOWNLOAD				:String = "DOWNLOAD";
		public static const COMMIT_DETAILS			:String = "COMMIT_DETAILS";
		public static const CLOSE_MODAL_WINDOW		:String = "CLOSE_MODAL_WINDOW";
		public static const SHOW_HISTORY			:String = "SHOW_HISTORY";
		public static const HISTORY_DRAWN			:String = "HISTORY_DRAWN";
		public static const ABOUT_GIT				:String = "ABOUT_GIT";
		public static const GLOBAL_SETTINGS			:String = "GLOBAL_SETTINGS";
		public static const GITHUB_HOME				:String = "GITHUB_HOME";
		public static const GITHUB_LOGIN			:String = "GITHUB_LOGIN";
		public static const DRAG_AND_DROP			:String = "DRAG_AND_DROP";
		public static const FILE_BROWSER_CANCELED	:String = "FILE_BROWSER_CANCELED";
		public static const FILE_BROWSER_SELECTION	:String = "FILE_BROWSER_SELECTION";
		public static const LIST_ITEM_SELECTED		:String = "LIST_ITEM_SELECTED";
		public static const DIRECTORY_SELECTED		:String = "DIRECTORY_SELECTED";
		public static const TOGGLE_OPEN_DIRECTORY:String = "TOGGLE_OPEN_DIRECTORY";
		public static const ANONYMOUS_CLONE:String = "ANONYMOUS_CLONE";
		
		public var data:Object;

		public function UIEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, true, true);
		}
		
	}
	
}
