package events {
	import flash.events.Event;

	public class AppEvent extends Event {
				
		public static const SHOW_ALERT				:String = "SHOW_ALERT";
		public static const HIDE_ALERT				:String = "HIDE_ALERT";		
		public static const SHOW_DEBUG				:String = "SHOW_DEBUG";
		public static const HIDE_DEBUG				:String = "HIDE_DEBUG";	
		public static const SHOW_LOADER				:String = 'SHOW_LOADER';
		public static const HIDE_LOADER				:String = 'HIDE_LOADER';
			
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
		
		public var data:Object;

		public function AppEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
