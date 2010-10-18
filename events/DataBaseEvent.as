package events {
	import flash.events.Event;

	public class DataBaseEvent extends Event {
		
		public static const DATABASE_READY			:String = "DATABASE_READY";
		public static const TRANSACTION_COMPLETE	:String = "TRANSACTION_COMPLETE";
		
		public static const REPOSITORIES			:String = "REPOSITORIES";
		public static const BOOKMARK_ADDED			:String = "BOOKMARK_ADDED";
		public static const BOOKMARK_DELETED:String = "BOOKMARK_DELETED";
		public var data:Object;
		
		public function DataBaseEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
