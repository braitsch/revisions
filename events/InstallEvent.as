package events {
	import flash.events.Event;

	public class InstallEvent extends Event {
		
		public static const SETTINGS				:String = "SETTINGS";
		public static const SET_GIT_VERSION			:String = "SET_GIT_VERSION";
		public static const GIT_UNAVAILABLE			:String = "GIT_UNAVAILABLE";
		public static const GIT_INSTALL_COMPLETE	:String = "GIT_INSTALL_COMPLETE";
		
		public static const UPDATE_AVAILABLE:String = "UPDATE_AVAILABLE";
		public static const UPDATE_PROGRESS:String = "UPDATE_PROGRESS";
		public static const UPDATE_COMPLETE:String = "UPDATE_COMPLETE";
		public static const UPDATE_ERROR:String = "UPDATE_ERROR";
		
		public var data:Object;

		public function InstallEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
