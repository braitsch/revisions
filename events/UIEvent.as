package events {
	import flash.events.Event;

	// events dispatched from user interaction that bubble through the display list //
	// generally these should bring up a modal window from within the modal manager //
	public class UIEvent extends Event {
		
	// adding and editing local bookmarks //	
		public static const ADD_BOOKMARK			:String = "ADD_BOOKMARK";
		public static const DRAG_AND_DROP			:String = "DRAG_AND_DROP";		public static const EDIT_BOOKMARK			:String = "EDIT_BOOKMARK";
		public static const ADD_BKMK_TO_ACCOUNT		:String = "ADD_BKMK_TO_ACCOUNT";
		
		public static const SHOW_HISTORY			:String = "SHOW_HISTORY";
		public static const GLOBAL_SETTINGS			:String = "GLOBAL_SETTINGS";

	// remote specific views //
		public static const GITHUB_HOME				:String = "GITHUB_HOME";
		public static const GITHUB_LOGIN			:String = "GITHUB_LOGIN";
		public static const BEANSTALK_HOME			:String = "BEANSTALK_HOME";
		public static const BEANSTALK_LOGIN			:String = "BEANSTALK_LOGIN";
		public static const LOGGED_IN_CLONE			:String = "LOGGED_IN_CLONE";
	
	// miscellaneous //	
		public static const CONFIRM					:String = "CONFIRM";
		public static const NO_BUTTON				:String = "NO_BUTTON";		
		public static const ENTER_KEY				:String = "ENTER_KEY";
		public static const CLOSE_MODAL_WINDOW		:String = "CLOSE_MODAL_WINDOW";
		public static const FILE_BROWSER_SELECTION	:String = "FILE_BROWSER_SELECTION";
		
	// file viewer actions //	
		public static const FILE_SELECTED			:String = "FILE_SELECTED";
		public static const TOGGLE_DIRECTORY		:String = "TOGGLE_DIRECTORY";
		
		public static const WIZARD_PREV				:String = "WIZARD_PREV";
		public static const WIZARD_NEXT				:String = "WIZARD_NEXT";
		public static const GET_COLLABORATORS		:String = "GET_COLLABORATORS";
		public static const ADD_COLLABORATOR		:String = "ADD_COLLABORATOR";
		public static const KILL_COLLABORATOR		:String = "KILL_COLLABORATOR";
		public static const RADIO_SELECTED			:String = "RADIO_SELECTED";
		public static const UNLINK_ACCOUNT			:String = "UNLINK_ACCOUNT";
		public static const COMMIT_OPTIONS			:String = "COMMIT_OPTIONS";
		
		public static const PAGE_HISTORY			:String = "PAGE_HISTORY";
		public static const COMBO_HEADING_OVER		:String = "COMBO_HEADING_OVER";
		public static const COMBO_HEADING_CLICK		:String = "COMBO_HEADING_CLICK";
		public static const COMBO_OPTION_KILL		:String = "COMBO_OPTION_KILL";
		public static const COMBO_OPTION_CLICK		:String = "COMBO_OPTION_CLICK";
		
		public var data:Object;

		public function UIEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, true, true);
		}
		
	}
	
}
