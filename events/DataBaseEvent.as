package events {
	import flash.events.Event;

	public class DataBaseEvent extends Event {
		
		public static const DATABASE_READY			:String = "DATABASE_READY";
		public static const TRANSACTION_COMPLETE	:String = "TRANSACTION_COMPLETE";
		
		public static const BOOKMARKS_READ			:String = "BOOKMARKS_READ";
		public static const RECORD_ADDED			:String = "RECORD_ADDED";
		public static const RECORD_EDITED			:String = "RECORD_EDITED";
		public static const RECORD_DELETED			:String = "RECORD_DELETED";
		
		public var data:Object;
		
		public function DataBaseEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
