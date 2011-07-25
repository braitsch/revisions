package system{

	public class BashMethods {
		
	// config methods //
		public static const DETECT_GIT			:String = 'getGitDetails';
		public static const HOMEBREW			:String = 'updateHomebrew';
		public static const MACPORTS			:String = 'updateMacports';				
		public static const INSTALL_GIT			:String = 'installGit';
		public static const SET_USER_NAME		:String = 'setUserName';
		public static const GET_USER_NAME		:String = 'getUserName';	
		public static const SET_USER_EMAIL		:String = 'setUserEmail';
		public static const GET_USER_EMAIL		:String = 'getUserEmail';	
		public static const GET_USER_REAL_NAME	:String = 'getLoggedInUsersRealName';
		
	// editor methods //		
		public static const COMMIT				:String = 'commit';
		public static const TRACK_FILE			:String = 'trackFile';
		public static const UNTRACK_FILE		:String = 'unTrackFile';
		public static const EDIT_GIT_DIR		:String = 'editGitDir';
		public static const INIT_FOLDER			:String = 'initFolder';		public static const INIT_FILE			:String = 'initFile';
		public static const KILL_FILE			:String = 'killFile';
		public static const KILL_FOLDER			:String = 'killFolder';
		
		public static const GET_BRANCHES		:String = 'getBranches';
		public static const GET_STASH_LIST		:String = 'getStashList';
		public static const DOWNLOAD_VERSION	:String = 'downloadVersion';
		public static const REVERT_TO_VERSION	:String = 'revertToVersion';
		
	// history & status //	
		public static const GET_HISTORY			:String = 'getHistory';
		public static const GET_LAST_COMMIT		:String = 'getLastCommit';
		public static const GET_TOTAL_COMMITS	:String = 'getTotalCommits';
		public static const GET_MODIFIED_FILES	:String = 'getModifiedFiles';
		public static const GET_TRACKED_FILES	:String = 'getTrackedFiles';
		public static const GET_UNTRACKED_FILES	:String = 'getUntrackedFiles';
		public static const GET_IGNORED_FILES	:String = 'getIgnoredFiles';
		
	// github & beanstalk	
		public static const GET_ACCOUNT_INFO	:String = 'getAccountInfo';
		public static const LOGIN				:String = 'login';
		public static const LOGOUT				:String = 'logout';
		public static const DETECT_SSH_KEYS		:String = 'checkForSSHKeys';
		public static const ADD_KEYS_TO_GITHUB	:String = 'addKeysToGitHub';
		
		public static const CLONE				:String = 'clone';
		public static const REPOSITORIES		:String = 'getRepositories';
		
	}
	
}


