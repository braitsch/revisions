package events {
	import flash.events.Event;

	// events dispatched from user interaction that bubble through the display list //
	// generally these should bring up a modal window from within the modal manager //
	public class UIEvent extends Event {
		
	// adding and editing local bookmarks //	
		public static const ADD_BOOKMARK			:String = "ADD_BOOKMARK";
		public static const DRAG_AND_DROP			:String = "DRAG_AND_DROP";		public static const EDIT_BOOKMARK			:String = "EDIT_BOOKMARK";
		public static const ADD_BKMK_TO_ACCOUNT		:String = "ADD_REMOTE_TO_BOOKMARK";
			// adding and editing local branches //	
		public static const DELETE_BRANCH			:String = "DELETE_BRANCH";
		
	// history view actions //	
		public static const REVERT					:String = "REVERT";
		public static const DOWNLOAD				:String = "DOWNLOAD";
		public static const SHOW_COMMIT				:String = "SHOW_COMMIT";
		
	// main toolbar actions //
		public static const ABOUT_GIT				:String = "ABOUT_GIT";
		public static const GLOBAL_SETTINGS			:String = "GLOBAL_SETTINGS";
		
	// summary view actions //	
		public static const COMMIT					:String = "COMMIT";
		public static const SYNC_REMOTES			:String = "SYNC_REMOTES";
		public static const SHOW_HISTORY			:String = "SHOW_HISTORY";

	// remote specific views //
		public static const GITHUB_HOME				:String = "GITHUB_HOME";
		public static const GITHUB_LOGIN			:String = "GITHUB_LOGIN";
		public static const BEANSTALK_HOME			:String = "BEANSTALK_HOME";
		public static const BEANSTALK_LOGIN			:String = "BEANSTALK_LOGIN";
		public static const LOGGED_IN_CLONE			:String = "LOGGED_IN_CLONE";
	
	// miscellaneous //	
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
		public static const SET_PERMISSIONS			:String = "SET_PERMISSIONS";
		
		public var data:Object;

		public function UIEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, true, true);
		}
		
	}
	
}
