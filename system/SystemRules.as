package system {

	public class SystemRules {
		
		public static const MIN_GIT_VERSION			:String = '1.7.5.4';
		public static const TRACK_HIDDEN_FILES		:Boolean = false;
		public static const SHOW_GIT_REPOSITORY		:Boolean = false;		public static const FORBIDDEN_FILES			:Vector.<String> = Vector.<String>(['.DS_Store']);
		
	// mac install locations //	
		public static const MACPORTS				:String = '/opt/local/bin/git';
		public static const HOMEBREW				:String = '/usr/local/bin/git';
		public static const GIT_SCM_DMG 			:String = '/usr/local/git/bin/git';
		
	}
	
}
