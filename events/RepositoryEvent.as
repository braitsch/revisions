package events {
	import flash.events.Event;

	public class RepositoryEvent extends Event {
		
		public static const SET_USERNAME					:String = "SET_USERNAME";
		public static const INITIALIZED						:String = 'INITIALIZED';
	
		public static const BOOKMARK_SET					:String = "BOOKMARK_SET";				public static const BOOKMARK_LIST					:String = "BOOKMARKS_READY";		public static const BOOKMARK_ADDED					:String = "BOOKMARK_ADDED";		public static const BOOKMARK_EDITED					:String = "BOOKMARK_EDITED";
		public static const BOOKMARK_ERROR					:String = "BOOKMARK_ERROR";
		public static const BOOKMARK_DELETED				:String = "BOOKMARK_DELETED";
		
		public static const STASH_LIST_READ					:String = "STASH_LIST_READ";
		public static const BRANCHES_READ					:String = "BRANCHES_READ";
		public static const QUEUE_BRANCHES_READ				:String = "QUEUE_BRANCHES_READ";
		public static const BRANCH_ADDED					:String = "BRANCH_ADDED";
		public static const BRANCH_STATUS					:String = "BRANCH_STATUS";
		public static const BRANCH_HISTORY					:String = "HISTORY_RECEIVED";
		public static const BRANCH_DETACHED					:String = "BRANCH_DETACHED";
		public static const BRANCH_MODIFIED					:String = "BRANCH_MODIFIED";
		public static const COMMIT_MODIFIED					:String = "COMMIT_MODIFIED";
			
		public var data:Object;
		
		public function RepositoryEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
