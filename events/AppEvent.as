package events {
	import flash.events.Event;

	public class AppEvent extends Event {
				
		public static const SHOW_ALERT				:String = "SHOW_ALERT";
		public static const HIDE_ALERT				:String = "HIDE_ALERT";		
		public static const SHOW_DEBUG				:String = "SHOW_DEBUG";
		public static const HIDE_DEBUG				:String = "HIDE_DEBUG";	
		public static const SHOW_CONFIRM			:String = "SHOW_CONFIRM";
		public static const HIDE_CONFIRM			:String = "HIDE_CONFIRM";
		public static const SHOW_LOADER				:String = 'SHOW_LOADER';
		public static const HIDE_LOADER				:String = 'HIDE_LOADER';
		public static const LOADER_TEXT				:String = "LOADER_TEXT";
		public static const LOADER_PERCENT			:String = "LOADER_PERCENT";
			
		public static const APP_SETTINGS			:String = "APP_SETTINGS";
		public static const APP_EXPIRED				:String = "APP_EXPIRED";
		public static const APP_UP_TO_DATE			:String = "APP_UP_TO_DATE";
		public static const APP_UPDATE_AVAILABLE	:String = "APP_UPDATE_AVAILABLE";
		public static const APP_UPDATE_IGNORED		:String = "APP_UPDATE_IGNORED";
		public static const APP_UPDATE_PROGRESS		:String = "APP_UPDATE_PROGRESS";
		public static const APP_UPDATE_COMPLETE		:String = "APP_UPDATE_COMPLETE";
		public static const APP_UPDATE_FAILURE		:String = "APP_UPDATE_FAILURE";
		
		public static const GIT_NOT_INSTALLED		:String = "GIT_UNAVAILABLE";
		public static const GIT_NEEDS_UPDATING		:String = "GIT_NEEDS_UPDATING";
		public static const GIT_INSTALL_COMPLETE	:String = "GIT_INSTALL_COMPLETE";
		public static const GIT_SETTINGS			:String = "GIT_SETTINGS";
		public static const GIT_NAME_AND_EMAIL		:String = "GIT_NAME_AND_EMAIL";		
		public static const GIT_DIR_UPDATED			:String = "GIT_DIR_UPDATED";
		
		public static const LOGOUT					:String = "LOGOUT";
		public static const LOGIN_SUCCESS			:String = "LOGIN_SUCCESS";
		public static const LOGOUT_SUCCESS			:String = "LOGOUT_SUCCESS";
		public static const REMOTE_READY			:String = "REMOTE_READY";
		public static const SSH_KEY_READY			:String = "SSH_KEYS_READY";
		
	// remote calls //	
		public static const REMOTE_SYNCED			:String = "REMOTE_SYNCED";
		public static const CLONE_COMPLETE			:String = "CLONE_COMPLETE";
		public static const REPOSITORY_CREATED		:String = "REPOSITORY_CREATED";
		public static const HISTORY_RENDERED		:String = "HISTORY_READY";
		
		public static const REQUESTING_HISTORY		:String = "REQUESTING_HISTORY";
		public static const REPOSITORY_READY		:String = "REPOSITORY_READY";
		public static const FILES_DELETED			:String = "FILES_DELETED";
		public static const HISTORY_REQUESTED		:String = "HISTORY_REQUESTED";
		public static const MODIFIED_REQUESTED		:String = "MODIFIED_REQUESTED";
		public static const REMOTE_KEY_SET			:String = "REMOTE_KEY_VALIDATED";
		public static const PROMPT_FOR_REMOTE_PSWD	:String = "PROMPT_FOR_REMOTE_PSWD";
		
		public static const FAILURE:String = "FAILURE";
		
		public var data:Object;

		public function AppEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
