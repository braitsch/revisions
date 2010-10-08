package events {
	import flash.events.Event;

	public class RepositoryEvent extends Event {
		
		public static const SET_USERNAME:String = "SET_USERNAME";
		
		public static const REFRESH_STATUS:String = "REFRESH_STATUS";
		public static const REFRESH_HISTORY:String = "REFRESH_HISTORY";
		
		public static const STATUS_RECEIVED:String = "STATUS_RECEIVED";
		public static const HISTORY_RECEIVED:String = "HISTORY_RECEIVED";
		public static const HISTORY_UNAVAILABLE:String = "HISTORY_UNAVAILABLE";	
		
		public static const BRANCH_CHANGED:String = "BRANCH_CHANGED";
		public static const BOOKMARKS_READY:String = "BOOKMARKS_READY";
		public static const BOOKMARK_SELECTED:String = "BOOKMARK_SELECTED";
		
		public static const BRANCH_LIST_RECEIVED:String = "BRANCH_LIST_RECEIVED";			
		public var data:Object;
		
		public function RepositoryEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
