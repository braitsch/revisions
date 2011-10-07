package events {
	import flash.events.Event;

	public class AppEvent extends Event {
				
		public static const SHOW_ALERT					:String = "SHOW_ALERT";
		public static const HIDE_ALERT					:String = "HIDE_ALERT";	
		
		public static const SHOW_LOADER					:String = 'SHOW_LOADER';
		public static const HIDE_LOADER					:String = 'HIDE_LOADER';
		public static const LOADER_TEXT					:String = "LOADER_TEXT";
		public static const LOADER_PERCENT				:String = "LOADER_PERCENT";
			
		public static const SSH_KEY_READY				:String = "SSH_KEY_READY";
		public static const APP_SETTINGS				:String = "APP_SETTINGS";
		public static const APP_EXPIRED					:String = "APP_EXPIRED";
		public static const APP_UP_TO_DATE				:String = "APP_UP_TO_DATE";
		public static const APP_UPDATE_AVAILABLE		:String = "APP_UPDATE_AVAILABLE";
		public static const APP_UPDATE_IGNORED			:String = "APP_UPDATE_IGNORED";
		public static const APP_UPDATE_PROGRESS			:String = "APP_UPDATE_PROGRESS";
		public static const APP_UPDATE_COMPLETE			:String = "APP_UPDATE_COMPLETE";
		public static const APP_UPDATE_FAILURE			:String = "APP_UPDATE_FAILURE";
		
		public static const GIT_NOT_INSTALLED			:String = "GIT_NOT_INSTALLED";
		public static const GIT_NEEDS_UPDATING			:String = "GIT_NEEDS_UPDATING";
		public static const GIT_INSTALL_COMPLETE		:String = "GIT_INSTALL_COMPLETE";
		public static const GIT_SETTINGS				:String = "GIT_SETTINGS";
		public static const GIT_DIR_UPDATED				:String = "GIT_DIR_UPDATED";
		
		public static const CLONE_COMPLETE				:String = "CLONE_COMPLETE";
		public static const REPOSITORY_CREATED			:String = "REPOSITORY_CREATED";
		public static const BKMK_ADDED_TO_ACCOUNT		:String = "BKMK_ADDED_TO_ACCOUNT";
		
		public static const REPOSITORY_READY			:String = "REPOSITORY_READY";
		public static const FILES_DELETED				:String = "FILES_DELETED";
		public static const HISTORY_REQUESTED			:String = "HISTORY_REQUESTED";
		public static const HISTORY_RECEIVED			:String = "HISTORY_RECEIVED";
		public static const MODIFIED_RECEIVED			:String = "MODIFIED_RECEIVED";		
		public static const SUMMARY_RECEIVED			:String = "SUMMARY_RECEIVED";
		
		public static const LOGIN_SUCCESS				:String = "LOGIN_SUCCESS";
		public static const REMOTE_KEY_READY			:String = "REMOTE_KEY_READY";
		public static const PERMISSIONS_FAILURE			:String = "PERMISSIONS_FAILURE";
		public static const RETRY_REMOTE_REQUEST		:String = "RETRY_REMOTE_REQUEST";
		public static const AVATAR_LOADED				:String = "AVATAR_LOADED";
		public static const COLLABORATOR_ADDED			:String = "COLLABORATOR_ADDED";
		public static const COLLABORATORS_RECEIEVED		:String = "COLLABORATORS_RECEIEVED";
		
		public static const BRANCH_PUSHED				:String = "BRANCH_PUSHED";
		public static const BRANCH_STATUS				:String = "BRANCH_STATUS";
		public static const BRANCH_RENAMED				:String = "BRANCH_RENAMED";
		public static const BRANCH_DELETED				:String = "BRANCH_DELETED";
		public static const BRANCH_CHANGED				:String = "BRANCH_CHANGED";		
		public static const REMOTE_ADDED				:String = "REMOTE_ADDED";
		public static const REMOTE_EDITED				:String = "REMOTE_EDITED";
		public static const REMOTE_DELETED				:String = "REMOTE_DELETED";		
		
		public static const INITIALIZED					:String = 'INITIALIZED';
		public static const NO_BOOKMARKS				:String = "NO_BOOKMARKS";
		public static const PATH_ERROR					:String = "PATH_ERROR";
		public static const BOOKMARK_REPAIRED			:String = "BOOKMARK_REPAIRED";
		public static const BOOKMARKS_LOADED			:String = "BOOKMARKS_LOADED";
		public static const BOOKMARK_ADDED				:String = "BOOKMARK_ADDED";
		public static const BOOKMARK_DELETED			:String = "BOOKMARK_DELETED";
		public static const BOOKMARK_SELECTED			:String = "BOOKMARK_SELECTED";
		public static const BOOKMARK_EDITED				:String = "BOOKMARK_EDITED";
		public static const BOOKMARK_REVERTED			:String = "BOOKMARK_REVERTED";
		public static const COMMIT_COMPLETE				:String = "COMMIT_COMPLETE";
		public static const MERGE_COMPLETE				:String = "MERGE_COMPLETE";
		
		public var data:Object;

		public function AppEvent(type:String, obj:Object = null)
		{
			data = obj;
			super(type, false, false);
		}
		
	}
	
}
