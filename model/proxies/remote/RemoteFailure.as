package model.proxies.remote {

	public class RemoteFailure {
		
		public static const	AUTHENTICATION	:String = 'authentication';
		public static const	MALFORMED_URL	:String = 'malformed-url';
		public static const	REPO_NOT_FOUND	:String = 'repository-not-found';
		
		private static var _keyErrors:Vector.<String> = new <String>[	
			'Permission denied',
			'Authentication failed',
			'403 while accessing',
			'Host key verification failed',
			'Your key is not attached to the repository and account you are trying to access.'];
			
		private static var _urlErrors:Vector.<String> = new <String>[	
			'Unable to find remote helper',
			'does not exist',
			'Could not find Repository',
			'Failed connect to',
			'Couldn\'t resolve host'	];
			
		private static var _repoErrors:Vector.<String> = new <String>[	
			'git/info/refs not found',
			'doesn\'t exist. Did you enter it correctly?'	];			
		
		public static function detectFailure(s:String):String
		{
			if (detectErrors(_keyErrors, s)){
				return AUTHENTICATION;
			}	else if (detectErrors(_urlErrors, s)){
				return MALFORMED_URL;
			}	else if (detectErrors(_repoErrors, s)){
				return REPO_NOT_FOUND;
			}	else{
				return null;	
			}
		}	
		
		private static function detectErrors(v:Vector.<String>, s:String):Boolean
		{
			for (var i:int = 0; i < v.length; i++) {
				if (hasString(s, v[i])) return true;
			}
			return false;
		}
		
		private static function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }						
		
	}
	
}
