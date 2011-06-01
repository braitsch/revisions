package events {
	import flash.events.Event;

	public class BookmarkEvent extends Event {
		
		public static const SET_USERNAME					:String = "SET_USERNAME";
	
		public static const LOADED							:String = "bookmarks_loaded";
		public static const NO_BOOKMARKS					:String = "no_bookmarks";
		public static const INITIALIZED						:String = 'initialized';
		public static const SELECTED						:String = "selected";
		public static const STATUS							:String = "status";
		public static const HISTORY							:String = "received";
		public static const EDITED							:String = "edited";
		public static const PATH_ERROR						:String = "path_error";
		
		public static const STASH_LIST_READ					:String = "STASH_LIST_READ";
		public static const BRANCHES_READ					:String = "BRANCHES_READ";
		public static const QUEUE_BRANCHES_READ				:String = "QUEUE_BRANCHES_READ";
		public static const BRANCH_ADDED					:String = "BRANCH_ADDED";
		public static const BRANCH_DETACHED					:String = "BRANCH_DETACHED";
		public static const BRANCH_MODIFIED					:String = "BRANCH_MODIFIED";
		public static const COMMIT_MODIFIED:String = "COMMIT_MODIFIED";
		public static const UNTRACKED_FILES:String = "UNTRACKED_FILES";
		
			
		public var data:Object;
		
		public function BookmarkEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}