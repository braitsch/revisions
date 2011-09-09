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
		
	}
	
}
