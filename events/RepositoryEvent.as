package events {
	import flash.events.Event;

	public class RepositoryEvent extends Event {
		
		public static const SET_USERNAME			:String = "SET_USERNAME";
		public static const BOOKMARKS_READY			:String = "BOOKMARKS_READY";
		
		public static const BOOKMARK_SET			:String = "BOOKMARK_SET";
		public static const BRANCH_SET				:String = "BRANCH_SET";
		
		public static const BRANCH_STATUS			:String = "BRANCH_STATUS";
		public static const BRANCH_MODIFIED			:String = "BRANCH_MODIFIED";
		public static const BRANCH_DETACHED			:String = "BRANCH_DETACHED";
		public static const BRANCH_HISTORY			:String = "HISTORY_RECEIVED";
		public static const HISTORY_UNAVAILABLE		:String = "HISTORY_UNAVAILABLE";
		public static const BOOKMARK_ERROR		:String = "BOOKMARK_PATH_ERROR";
		public static const COMMIT_MODIFIED		:String = "DETACHED_BRANCH_EDITED";		
		
		public var data:Object;
		
		public function RepositoryEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
