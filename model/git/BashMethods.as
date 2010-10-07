package model.git{

	public class BashMethods {
		
	// install methods //	
		public static const GET_VERSION:String = 'getVersion';
		public static const DOWNLOAD:String = 'download';
		public static const MOUNT:String = 'mount';
		public static const INSTALL:String = 'install';
		public static const UNMOUNT:String = 'unmount';
		public static const TRASH:String = 'trash';

	// editor methods //		
		public static const COMMIT:String = 'commit';
		public static const TRACK_FILE:String = 'trackFile';		public static const UNTRACK_FILE:String = 'unTrackFile';
		public static const INIT_REPOSITORY:String = 'initRepository';
		public static const DELETE_REPOSITORY:String = 'deleteRepository';
		
	// branch methods //	
		public static const GET_BRANCHES:String = 'getBranches';

	// history methods //		
		public static const GET_HISTORY:String = 'getHistory';		public static const CHECKOUT_MASTER:String = 'checkoutMaster';		public static const CHECKOUT_COMMIT:String = 'checkoutCommit';		public static const CHECKOUT_BRANCH:String = 'checkoutBranch';
		
	// status methods //	
		public static const GET_MODIFIED_FILES:String = 'getModifiedFiles';
		public static const GET_TRACKED_FILES:String = 'getTrackedFiles';
		public static const GET_UNTRACKED_FILES:String = 'getUntrackedFiles';
		public static const GET_IGNORED_FILES:String = 'getIgnoredFiles';
	}
}
