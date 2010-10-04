package utils {

	public class StringUtils {
		
		public static function trim(s:String):String
		{
			return s.replace(/^\s+|\s+$/g, '');			
		}
		
		public static function hasTrailingWhiteSpace(s:String):Boolean
		{
			return s.search(/\s+$/)!=-1;			
		}
		
	}
	
}
