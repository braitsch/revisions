package system {

	import flash.filesystem.File;
	public class FileUtils {
		
		public static function dirIsEmpty(f:File):Boolean
		{
			if (f.isDirectory) {
				var a:Array = f.getDirectoryListing();
				for (var i:int = 0; i < a.length; i++) if (a[i].isHidden == false) return false;
				return true;
			}
			return false;			
		}
		
	}
	
}
