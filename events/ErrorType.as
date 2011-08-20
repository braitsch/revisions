package events {

	public class ErrorType {
	
	// connection errors //	
		public static const LOGIN_FAILURE		:String = 'Login Attempt Failed.\nPlease Check Your Credentials.';
		public static const NO_CONNECTION		:String = 'Could not connect to remote server.\nPlease check your internet connection';
		public static const UNRESOLVED_HOST		:String = 'Could not connect to server, did you enter the URL correctly?';
		public static const SERVER_FAILURE		:String = 'The server you\'re trying to reach does not appear to be responding. Please try again in a few moments.';
	
	// account specific errors //
		public static const REPO_NOT_FOUND		:String = "Could not find that repository, did you enter the URL correctly?";
		public static const REPOSITORY_TAKEN	:String = 'That repository name is already taken, please choose something else';
		public static const OVER_QUOTA			:String = 'Whoops! Looks like you\'re all out of private repositories, consider making this one public or upgrade your account.';
		
	}
	
}
