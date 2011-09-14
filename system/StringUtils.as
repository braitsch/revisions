package system {

	public class StringUtils {
		
		public static function trim(s:String):String
		{
			return s.replace(/^\s+|\s+$/g, '');			
		}
		
		public static function hasTrailingWhiteSpace(s:String):Boolean
		{
			return s.search(/\s+$/)!=-1;			
		}
		
		public static function capitalize(s:String):String
		{
			return s.substr(0, 1).toUpperCase()+s.substr(1);
		}
		
		public static function validateEmail(s:String):Boolean
		{
			return s.search(/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/) != -1;
		}
		
		public static function parseISO8601Date(x:String):Date
		{
			var y:String = x.substr(0, 4);
			var m:String = x.substr(5, 2);
			var d:String = x.substr(8, 2);
			var h:String = x.substr(11, 2);
			var n:String = x.substr(14, 2);
			var s:String = x.substr(17, 2);
			return new Date(y, m, d, h, n, s);
		}		
		
	}
	
}
