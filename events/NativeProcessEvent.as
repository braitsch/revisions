package events {
	import flash.events.Event;

	public class NativeProcessEvent extends Event {
		
		public static const DATA_RECEIVED		:String = "DATA_RECEIVED";
		public static const PROCESS_FAILURE		:String = "PROCESS_FAILURE";
		public static const PROCESS_COMPLETE	:String = "PROCESS_COMPLETE";	
		public static const QUEUE_COMPLETE		:String = "QUEUE_COMPLETE";			
		
		public var data:Object;
		
		public function NativeProcessEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, false, false);
		}
	}
}
