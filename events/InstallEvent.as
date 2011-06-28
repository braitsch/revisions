package events {
	import flash.events.Event;

	public class InstallEvent extends Event {
		
		public static const GIT_NOT_INSTALLED		:String = "GIT_UNAVAILABLE";
		public static const GIT_NEEDS_UPDATING		:String = "GIT_NEEDS_UPDATING";
		public static const GIT_INSTALL_COMPLETE	:String = "GIT_INSTALL_COMPLETE";
		public static const GIT_SETTINGS			:String = "GIT_SETTINGS";
		public static const APP_SETTINGS			:String = "APP_SETTINGS";
		public static const NAME_AND_EMAIL			:String = "NAME_AND_EMAIL";
		
		public static const APP_EXPIRED				:String = "APP_EXPIRED";
		public static const APP_UP_TO_DATE			:String = "APP_UP_TO_DATE";
		public static const IGNORE_UPDATE			:String = "IGNORE_UPDATE";
		public static const UPDATE_AVAILABLE		:String = "UPDATE_AVAILABLE";
		public static const UPDATE_PROGRESS			:String = "UPDATE_PROGRESS";
		public static const UPDATE_COMPLETE			:String = "UPDATE_COMPLETE";
		public static const UPDATE_FAILURE			:String = "UPDATE_FAILURE";
		public static const GIT_DIR_UPDATED			:String = "GIT_DIR_UPDATED";
		
		public static const INIT_START				:String = 'initStart';
		public static const INIT_COMPLETE:String = 'initComplete';
		
		public var data:Object;

		public function InstallEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
