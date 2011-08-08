package events {
	import flash.events.Event;

	public class DataBaseEvent extends Event {
		
		public static const DATABASE_OPENED			:String = "DATABASE_OPENED";
		public static const TRANSACTION_COMPLETE	:String = "TRANSACTION_COMPLETE";
		
		public static const DATABASE_READ			:String = "DATABASE_READ";
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
