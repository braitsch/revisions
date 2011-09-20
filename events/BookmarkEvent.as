package events {
	import flash.events.Event;

	public class BookmarkEvent extends Event {
		
		public static const LOADED							:String = "LOADED";
		public static const NO_BOOKMARKS					:String = "NO_BOOKMARKS";
		public static const INITIALIZED						:String = 'INITIALIZED';		public static const ADDED							:String = "ADDED";		public static const DELETED							:String = "DELETED";
		public static const SELECTED						:String = "SELECTED";
		public static const EDITED							:String = "EDITED";
		public static const PATH_ERROR						:String = "PATH_ERROR";
		public static const BRANCH_CHANGED					:String = "BRANCH_CHANGED";
		public static const COMMIT_COMPLETE					:String = "COMMIT_COMPLETE";
		public static const REVERTED						:String = "REVERTED";
			
		public var data:Object;
		
		public function BookmarkEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
