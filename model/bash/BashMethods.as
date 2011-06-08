package model.bash{

	public class BashMethods {
		
	// config methods //
		public static const GET_VERSION:String = 'getVersion';	
		public static const GET_USER_NAME:String = 'getUserName';	
		public static const GET_USER_EMAIL:String = 'getUserEmail';	
		
	// install methods //	
		public static const DOWNLOAD:String = 'download';
		public static const MOUNT:String = 'mount';
		public static const INSTALL:String = 'install';
		public static const UNMOUNT:String = 'unmount';
		public static const TRASH:String = 'trash';

	// editor methods //		
		public static const COMMIT:String = 'commit';		public static const TRACK_FILE:String = 'trackFile';
		public static const UNTRACK_FILE:String = 'unTrackFile';
		public static const INIT_FOLDER:String = 'initFolder';
		public static const INIT_FILE:String = 'initFile';
		public static const KILL_FILE:String = 'killFile';
		public static const KILL_FOLDER:String = 'killFolder';
		
	// branch methods //	
		public static const RESET_BRANCH:String = 'resetBranch';
		public static const ADD_BRANCH:String = 'addBranch';		public static const GET_BRANCHES:String = 'getBranches';	// history methods //		
		public static const GET_HISTORY:String = 'getHistory';
		public static const CHECKOUT_COMMIT:String = 'checkoutCommit';
		public static const CHECKOUT_BRANCH:String = 'checkoutBranch';
		public static const REVERT:String = 'revertToVersion';
		public static const DOWNLOAD_VERSION:String = 'downloadVersion';
		
	// status methods //	
		public static const GET_MODIFIED_FILES:String = 'getModifiedFiles';
		public static const GET_TRACKED_FILES:String = 'getTrackedFiles';
		public static const GET_UNTRACKED_FILES:String = 'getUntrackedFiles';
		public static const GET_NUM_IN_INDEX:String = 'getNumInIndex';
		public static const GET_IGNORED_FILES:String = 'getIgnoredFiles';
		
		public static const POP_STASH:String = 'popStash';
		public static const PUSH_STASH:String = 'pushStash';
		public static const GET_STASH_LIST:String = 'getStashList';
		
	}
	
}


