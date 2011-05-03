package events {
	import flash.events.Event;

	public class BookmarkEvent extends Event {
		
		public static const SET_USERNAME					:String = "SET_USERNAME";
	
		public static const INITIALIZED						:String = 'INITIALIZED';
		public static const ADDED							:String = "BOOKMARK_ADDED";		public static const SELECTED						:String = "BOOKMARK_SET";		public static const EDITED							:String = "BOOKMARK_EDITED";		public static const DELETED							:String = "BOOKMARK_DELETED";
		public static const PATH_ERROR						:String = "PATH_ERROR";
		
		public static const STASH_LIST_READ					:String = "STASH_LIST_READ";
		public static const BRANCHES_READ					:String = "BRANCHES_READ";
		public static const QUEUE_BRANCHES_READ				:String = "QUEUE_BRANCHES_READ";
		public static const BRANCH_ADDED					:String = "BRANCH_ADDED";
		public static const BRANCH_STATUS					:String = "BRANCH_STATUS";
		public static const BRANCH_HISTORY					:String = "HISTORY_RECEIVED";
		public static const BRANCH_DETACHED					:String = "BRANCH_DETACHED";
		public static const BRANCH_MODIFIED					:String = "BRANCH_MODIFIED";
		public static const COMMIT_MODIFIED					:String = "COMMIT_MODIFIED";
		
		public static const NO_BOOKMARKS					:String = "NO_BOOKMARKS";
		public static const BOOKMARKS_LOADED				:String = "BOOKMARKS_READY";
			
		public var data:Object;
		
		public function BookmarkEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
