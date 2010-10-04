package events {
	import flash.events.Event;

	public class RepositoryEvent extends Event {
		
		public static const STATUS:String = "STATUS";
		public static const HISTORY_RECEIVED:String = "HISTORY_RECEIVED";
		public static const HISTORY_UNAVAILABLE:String = "HISTORY_UNAVAILABLE";	
		
		public static const SET_BOOKMARK:String = "SET_BOOKMARK";
		public static const BRANCH_LIST_RECEIVED:String = "BRANCH_LIST_RECEIVED";			
		public var data:Object;
		
		public function RepositoryEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
		
	}
	
}
