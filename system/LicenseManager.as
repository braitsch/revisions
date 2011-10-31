package system {

	import com.adobe.crypto.SHA1;
	
	public class LicenseManager {

		private static var _key		:String = '56afea94f7c9cda8f96b6cebe53023c64d157a9f';
		private static var _expire	:Date = new Date(2011, 11, 1);
		private static var _secret	:String = '12345';
			
		static public function get key():String
		{
			return _key;
		}
		
		static public function checkExpired():Boolean
		{
			var now:Date = new Date();
			return now > _expire;
		}
		
		public static function validate($userKey:String):Boolean
		{
			var key:String = SHA1.hash(_secret + 'useremail');
			if (key != $userKey) return false;
			return true;
		}
		
	}
	
}
