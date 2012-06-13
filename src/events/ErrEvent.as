package events {

	import flash.events.Event;
	public class ErrEvent extends Event {
	
	// connection errors //	
		public static const LOGIN_FAILURE		:String = 'Login Attempt Failed.\nPlease Check Your Credentials.';
		public static const NO_CONNECTION		:String = 'Could not connect to remote server.\nPlease check your internet connection.';
		public static const UNRESOLVED_HOST		:String = 'Could not connect to server, did you enter the URL correctly?';
		public static const SERVER_FAILURE		:String = 'The server you\'re trying to reach does not appear to be responding. Please try again in a few moments.';
	
	// account specific errors //
		public static const REPO_NOT_FOUND		:String = 'Could not find that repository, did you enter the URL correctly?';
		public static const REPOSITORY_TAKEN	:String = 'That repository name is already taken, please choose something else.';
		public static const OVER_QUOTA			:String = 'Whoops! Looks like you\'re all out of private repositories, consider making this one public or upgrade your account.';
		public static const API_DISABLED		:String = 'It looks like remote access to your Beanstalk account is currently disabled. Not to fear, this is easily remedied by enabling the \'Developer API\' option in your account settings.';
		public static const COLLAB_NOT_FOUND	:String = 'Hmm, I can\'t seem to find that collaborator, are you sure you entered their name correctly?';
		public static const PERMISSIONS			:String = 'Whoops, something went wrong. Failed to update user permissions.';
		public static const UNAUTHORIZED		:String = 'You must be the account owner or have admin privileges to access your account through Revisions.';
		public static const USER_FORBIDDEN		:String = 'It appears that you do not have permission to access this repository. Please contact the repository owner to resolve the issue.';
	
		public function ErrEvent(type:String)
		{
			super(type, false, false);
		}	
		
	}
	
}
