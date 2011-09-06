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
		
	// repository creator methods //		
		public static const INIT_FILE				:String = 'initFile';
		public static const INIT_FOLDER				:String = 'initFolder';		public static const TRACK_FILE				:String = 'trackFile';
		public static const UNTRACK_FILE			:String = 'unTrackFile';
		public static const EDIT_GIT_DIR			:String = 'editGitDir';
		public static const GET_DIRECTORY_FILES		:String = 'getDirectoryFiles';		
		public static const ADD_INITIAL_COMMIT		:String = 'addInitialCommit';
		
	// repository editor methods //	
		public static const CLONE					:String = 'clone';
		public static const COMMIT					:String = 'commit';		
		public static const ADD_REMOTE				:String = 'addRemote';
		public static const EDIT_REMOTE				:String = 'editRemote';
		public static const PULL_REMOTE				:String = 'pullFromRemote';
		public static const PUSH_REMOTE				:String = 'pushToRemote';
		
	// repository reader methods //			
		public static const GET_STASH				:String = 'getStash';
		public static const GET_REMOTES				:String = 'getRemotes';
		public static const GET_LOCAL_BRANCHES		:String = 'getLocalBranches';
		public static const GET_REMOTE_BRANCHES		:String = 'getRemoteBranches';
		
	// checkout proxy //		
		public static const CHANGE_BRANCH			:String = 'checkoutBranch';
		public static const DOWNLOAD_VERSION		:String = 'downloadVersion';
		public static const REVERT_TO_VERSION		:String = 'revertToVersion';
		
	// history & status //	
		public static const GET_HISTORY				:String = 'getHistory';
		public static const GET_LAST_COMMIT			:String = 'getLastCommit';
		public static const GET_TOTAL_COMMITS		:String = 'getTotalCommits';
		public static const GET_TRACKED_FILES		:String = 'getTrackedFiles';
		public static const GET_UNTRACKED_FILES		:String = 'getUntrackedFiles';
		public static const GET_MODIFIED_FILES		:String = 'getModifiedFiles';
		public static const GET_IGNORED_FILES		:String = 'getIgnoredFiles';
		
	// github & beanstalk api methods //
		public static const LOGIN					:String = 'login';
		public static const LOGOUT					:String = 'logout';
		public static const GET_REPOSITORIES		:String = 'getRepositories';
		public static const ADD_BKMK_TO_ACCOUNT		:String = 'addBkmkToAccount';
		
	// remote keys //	
		public static const GET_REMOTE_KEYS			:String = 'getAllKeys';
		public static const ADD_KEY_TO_REMOTE		:String = 'addKeyToRemote';
		public static const REPAIR_REMOTE_KEY		:String = 'repairRemoteKey';
		public static const DELETE_KEY_FROM_REMOTE	:String = 'deleteKeyFromRemote';
		public static const ADD_NEW_KNOWN_HOST		:String = 'addNewKnownHost';
		
	// local keys //	
		public static const GET_HOST_NAME			:String = 'getHostName';
		public static const DETECT_SSH_KEY			:String = 'detectSSHKey';
		public static const CREATE_SSH_KEY			:String = 'createSSHKey';
		public static const ADD_KEY_TO_AUTH_AGENT	:String = 'addKeyToAuthAgent';
		
		public static const GET_REQUEST				:String = 'getRequest';
		public static const POST_REQUEST			:String = 'postRequest';
		public static const PUT_REQUEST				:String = 'putRequest';
		public static const PATCH_REQUEST			:String = 'patchRequest';
		public static const DELETE_REQUEST:String = 'deleteRequest';
		public static const ADD_COLLABORATOR:String = "ADD_COLLABORATOR";
		
	}
	
}


