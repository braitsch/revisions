package events {
	import flash.events.Event;

	public class RepositoryEvent extends Event {
		
		public static const SET_USERNAME		:String = "SET_USERNAME";
				
		public static const BOOKMARKS_READY		:String = "BOOKMARKS_READY";
		public static const BOOKMARK_SELECTED	:String = "BOOKMARK_SELECTED";
		
		public static const BRANCH_SELECTED		:String = "BRANCH_SELECTED";
		public static const BRANCH_STATUS		:String = "BRANCH_STATUS";
		public static const BRANCH_MODIFIED		:String = "BRANCH_MODIFIED";
		public static const BRANCH_HISTORY		:String = "HISTORY_RECEIVED";
		public static const HISTORY_UNAVAILABLE	:String = "HISTORY_UNAVAILABLE";	
		
		public var data:Object;
		
		public function RepositoryEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
