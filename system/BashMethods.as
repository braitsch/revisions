package system{

	public class BashMethods {
		
	// config methods //
		public static const DETECT_GIT				:String = 'detectGit';
		public static const INSTALL_GIT				:String = 'installGit';
		public static const SET_USER_NAME			:String = 'setUserName';
		public static const GET_USER_NAME			:String = 'getUserName';	
		public static const SET_USER_EMAIL			:String = 'setUserEmail';
		public static const GET_USER_EMAIL			:String = 'getUserEmail';	
		public static const GET_USER_REAL_NAME		:String = 'getLoggedInUsersRealName';
		
	// repo-creator.as //		
		public static const INIT_FILE				:String = 'initFile';
		public static const INIT_FOLDER				:String = 'initFolder';		public static const TRACK_FILE				:String = 'trackFile';
		public static const UNTRACK_FILE			:String = 'unTrackFile';
		public static const EDIT_GIT_DIR			:String = 'editGitDir';
		public static const GET_DIRECTORY_FILES		:String = 'getDirectoryFiles';		
		public static const ADD_INITIAL_COMMIT		:String = 'addInitialCommit';
		
	// repo-reader.as //			
		public static const GET_STASH				:String = 'getStash';
		public static const GET_REMOTES				:String = 'getRemotes';
		public static const GET_LOCAL_BRANCHES		:String = 'getLocalBranches';
		public static const GET_REMOTE_BRANCHES		:String = 'getRemoteBranches';
		
	// repo-remote.as //	
		public static const CLONE					:String = 'clone';
		public static const COMMIT					:String = 'commit';		
		public static const PUSH_BRANCH				:String = 'pushBranch';
		public static const TRASH_UNSAVED			:String = 'trashUnsaved';		
		
	// repo-editor.as //		
		public static const MERGE					:String = 'merge';
		public static const UN_MERGE				:String = 'unmerge';
		public static const ABSORB					:String = 'absorb';
		public static const ADD_BRANCH				:String = 'addBranch';
		public static const SET_BRANCH				:String = 'setBranch';
		public static const RENAME_BRANCH			:String = 'renameBranch';
		public static const DEL_BRANCH				:String = 'delBranch';
		public static const ADD_REMOTE				:String = 'addRemote';
		public static const EDIT_REMOTE				:String = 'editRemote';
		public static const DEL_REMOTE				:String = 'delRemote';
		public static const COPY_VERSION			:String = 'copyVersion';
		
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
		public static const ADD_REPOSITORY			:String = 'addRepository';
		public static const GET_COLLABORATORS		:String = 'getCollaborators';
		public static const ADD_COLLABORATOR		:String = 'addCollaborator';
		public static const KILL_COLLABORATOR		:String = 'killCollaborator';
		public static const GET_PERMISSIONS			:String = 'getPermissions';
		public static const SET_PERMISSIONS			:String = 'setPermissions';
		public static const SET_ADMINISTRATOR		:String = 'setAdministrator';		
		
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
		
		public static const STAR_COMMIT				:String = 'starCommit';
		public static const UNSTAR_COMMIT			:String = 'unstarCommit';
		public static const GET_FAVORITES			:String = 'getFavorites';
		public static const GET_REMOTE_FILES		:String = 'getRemoteFiles';
		public static const CHERRY_BRANCH			:String = 'cherryBranch';
		public static const ADD_TRACKING_BRANCHES	:String = 'addTrackingBranches';
		
	}
	
}


