package system{

	public class BashMethods {
		
	// config methods //
		public static const DETECT_GIT				:String = 'getGitDetails';
		public static const HOMEBREW				:String = 'updateHomebrew';
		public static const MACPORTS				:String = 'updateMacports';				
		public static const INSTALL_GIT				:String = 'installGit';
		public static const SET_USER_NAME			:String = 'setUserName';
		public static const GET_USER_NAME			:String = 'getUserName';	
		public static const SET_USER_EMAIL			:String = 'setUserEmail';
		public static const GET_USER_EMAIL			:String = 'getUserEmail';	
		public static const GET_USER_REAL_NAME		:String = 'getLoggedInUsersRealName';
		
	// repository creation & deletion methods //		
		public static const INIT_FILE				:String = 'initFile';
		public static const INIT_FOLDER				:String = 'initFolder';		public static const KILL_FILE				:String = 'killFile';
		public static const KILL_FOLDER				:String = 'killFolder';
		public static const TRACK_FILE				:String = 'trackFile';
		public static const UNTRACK_FILE			:String = 'unTrackFile';
		public static const EDIT_GIT_DIR			:String = 'editGitDir';
		public static const GET_DIRECTORY_FILES		:String = 'getDirectoryFiles';		
		public static const ADD_INITIAL_COMMIT		:String = 'addInitialCommit';
		
		public static const COMMIT					:String = 'commit';		
		public static const GET_STASH				:String = 'getStash';
		public static const GET_REMOTES				:String = 'getRemotes';
		public static const GET_LOCAL_BRANCHES		:String = 'getLocalBranches';
		public static const GET_REMOTE_BRANCHES		:String = 'getRemoteBranches';		
		public static const CHANGE_BRANCH			:String = 'checkoutBranch';
		public static const DOWNLOAD_VERSION		:String = 'downloadVersion';
		public static const REVERT_TO_VERSION		:String = 'revertToVersion';
		
	// history & status //	
		public static const GET_HISTORY				:String = 'getHistory';
		public static const GET_LAST_COMMIT			:String = 'getLastCommit';
		public static const GET_TOTAL_COMMITS		:String = 'getTotalCommits';
		public static const GET_MODIFIED_FILES		:String = 'getModifiedFiles';
		public static const GET_TRACKED_FILES		:String = 'getTrackedFiles';
		public static const GET_UNTRACKED_FILES		:String = 'getUntrackedFiles';
		public static const GET_IGNORED_FILES		:String = 'getIgnoredFiles';
		
	// ssh keys //	
		public static const DETECT_SSH_KEY			:String = 'detectSSHKeys';
		public static const GENERATE_SSH_KEY		:String = 'generateSSHKeys';
		public static const REGISTER_SSH_KEY		:String = 'registerSSHKeys';
		
	// github & beanstalk login methods //
		public static const LOGIN					:String = 'login';
		public static const LOGOUT					:String = 'logout';
		public static const GET_REPOSITORIES		:String = 'getRepositories';
		public static const GET_KEY_BY_ID			:String = 'getKeyById';
		public static const GET_ALL_REMOTE_KEYS		:String = 'getAllKeys';
		public static const ADD_KEY_TO_REMOTE		:String = 'addKeyToRemote';
		public static const REPAIR_REMOTE_KEY		:String = 'repairRemoteKey';
		public static const DELETE_KEY_FROM_REMOTE	:String = 'deleteKeyFromRemote';
		public static const AUTHENTICATE			:String = 'authenticate';
		
		public static const ADD_REPOSITORY			:String = 'newRepositoryOnAccount';
		public static const EDIT_REPOSITORY			:String = 'editRepository';
		public static const CLONE_REPOSITORY		:String = 'cloneRepository';
		
	// remote proxy methods //	
		public static const ADD_REMOTE				:String = 'addRemote';
		public static const PULL_REMOTE				:String = 'pullFromRemote';
		public static const PUSH_REMOTE				:String = 'pushToRemote';
		
		
	}
	
}


