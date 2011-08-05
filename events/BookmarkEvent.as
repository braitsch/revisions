package events {
	import flash.events.Event;

	public class BookmarkEvent extends Event {
		
		public static const LOADED							:String = "bookmarks_loaded";
		public static const NO_BOOKMARKS					:String = "no_bookmarks";
		public static const INITIALIZED						:String = 'initialized';		public static const ADDED							:String = "added";		public static const DELETED							:String = "deleted";
		public static const SELECTED						:String = "selected";
		public static const STATUS							:String = "status";
		public static const HISTORY_RECEIVED							:String = "received";
		public static const EDITED							:String = "edited";
		public static const PATH_ERROR						:String = "path_error";
		public static const BRANCH_CHANGED					:String = "branch_changed";
		
		public static const SUMMARY_RECEIVED							:String = "SUMMARY";
		public static const BRANCHES_READ					:String = "BRANCHES_READ";
		public static const STASH_LIST_READ					:String = "STASH_LIST_READ";
		public static const REMOTES_READ					:String = "REMOTES_READ";
		public static const COMMIT_COMPLETE:String = "COMMIT_COMPLETE";
		public static const REVERTED:String = "REVERTED";
			
		public var data:Object;
		
		public function BookmarkEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
