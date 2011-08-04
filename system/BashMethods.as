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
		
		public static const GET_STASH			:String = 'getStash';
		public static const GET_REMOTES			:String = 'getRemotes';
		public static const GET_LOCAL_BRANCHES	:String = 'getLocalBranches';
		public static const GET_REMOTE_BRANCHES	:String = 'getRemoteBranches';		
		public static const CHANGE_BRANCH		:String = 'checkoutBranch';
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
		
	// ssh keys //	
		public static const DETECT_SSH_KEYS		:String = 'detectSSHKeys';
		public static const DETECT_KEY_ID		:String = 'detectKeyId';
		public static const GENERATE_SSH_KEYS	:String = 'generateSSHKeys';
		public static const REGISTER_SSH_KEYS	:String = 'registerSSHKeys';
		
	// github & beanstalk	
		public static const GET_ACCOUNT_INFO	:String = 'getAccountInfo';
		public static const LOGIN				:String = 'login';
		public static const LOGOUT				:String = 'logout';
		public static const GET_GH_KEYS			:String = 'getGHKeys';
		public static const ADD_KEYS_TO_GH		:String = 'addKeysToGH';
		public static const REPAIR_GH_KEY		:String = 'repairGHKeys';
		public static const SAVE_GH_KEY_ID		:String = 'saveGHKeyId';
		public static const AUTHENTICATE_GH		:String = 'authenticateGH';
		
		public static const ADD_REPOSITORY		:String = 'addRepository';
		public static const EDIT_REPOSITORY		:String = 'editRepository';
		public static const GET_REPOSITORIES	:String = 'getRepositories';
		public static const CLONE_REPOSITORY	:String = 'cloneRepository';
		
	// remote proxy methods //	
		public static const ADD_REMOTE			:String = 'addRemote';
		public static const PULL_REMOTE			:String = 'pullFromRemote';
		public static const PUSH_REMOTE:String = 'pushToRemote';
		
	}
	
}


