package events {
	import flash.events.Event;

	public class ErrorEvent extends Event {
		
		public static const MULTIPLE_FILE_DROP	:String = 'Please drag only one file or folder at a time';		
		
		public var data:Object;

		public function ErrorEvent($type:String, $data:Object = null)
		{
			data = $data;
			super($type, true, true);
		}
		
	}
	
}
