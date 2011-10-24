package model.vo {

	import model.remote.HostingAccount;

	public class Repository {

		private var _id					:uint;
		private var _url				:String;
		private var _name				:String; // ex. github-revisions-source //
		private var _branches			:Array = [];
		private var _acctType			:String;
		private var _acctName			:String;
		private var _repoName			:String;
		private var _homePage			:String;
		private var _lastUpdated		:String;
		private var _collaborators		:Vector.<Collaborator>;

		public function Repository(name:String, url:String)
		{
			_name = name.toLowerCase(); _url = url;
			_acctType = getAccountType(url);
			_acctName = getAccountName(url);
			_repoName = getRepositoryName(url);
			_homePage = getRepositoryHomePage(url);
		}
		
		public function get id()			:uint 		{ return _id; 		    }
		public function get url()			:String 	{ return _url; 		    }
		public function get name()			:String 	{ return _name; 	    }
		public function get acctType()		:String 	{ return _acctType;	    }	
		public function get acctName()		:String 	{ return _acctName;	    }	
		public function get repoName()		:String 	{ return _repoName;		}
		public function get homePage()		:String 	{ return _homePage;		}
		public function get lastUpdated()	:String 	{ return _lastUpdated;  }
		
	// branches //	
		
		public function addBranch(s:String):void
		{
			_branches.push(s);
		}
		
		public function hasBranch(s:String):Boolean
		{
			for (var i:int = 0; i < _branches.length; i++) if (_branches[i] == s) return true;
			return false;
		}
		
		public function set lastUpdated(s:String):void
		{
			_lastUpdated = s;
		}
		
	// collaborators //
	
		public function set collaborators(v:Vector.<Collaborator>):void
		{
			_collaborators = v;
		}
		
		public function get collaborators():Vector.<Collaborator>
		{
			return _collaborators;	
		}
		
		public function killCollaborator(o:Collaborator):void
		{
			for (var i:int = 0; i < _collaborators.length; i++) {
				if (_collaborators[i] == o) _collaborators.splice(i, 1);
			}	
		}		
	
	// git@braitsch.beanstalkapp.com:/hello1234.git
	// git@github.com:braitsch/Revisions-Source.git
	// https://braitsch@github.com/braitsch/Revisions-Source.git
		
		public static function getAccountType(u:String):String
		{
			if (u.indexOf('@github.com') != -1){
				return HostingAccount.GITHUB;
			}	else if (u.indexOf('.beanstalkapp.com:/') != -1){
				return HostingAccount.BEANSTALK;		
			}	else{
				return 'unable to detect account type';		
			}
		}
		
		public static function getAccountName(u:String):String
		{
			if (u.indexOf('git@github.com') != -1 ){
				return u.substring(u.indexOf(':') + 1, u.indexOf('/'));
			}	else if (u.indexOf('github.com') != -1 ){
				u = u.substring(0, u.lastIndexOf('/'));
				return u.substr(u.lastIndexOf('/') + 1);
			}	else if (u.indexOf('.beanstalkapp.com:/') != -1){
				return u.substring(u.indexOf('@') + 1, u.indexOf('.'));				
			}	else{
				return 'unable to detect account name';		
			}
		}	
		
//		public static function getAccountName(u:String):String
//		{
//			if (u.indexOf('git@github.com') != -1 ){
//				return u.substring(u.indexOf(':') + 1, u.indexOf('/'));
//			}	else if (u.indexOf('https://') != -1 && u.indexOf('@github.com') != -1 ){
//				return u.substring(u.indexOf('/') + 2, u.indexOf('@'));
//			}	else if (u.indexOf('.beanstalkapp.com:/') != -1){
//				return u.substring(u.indexOf('@') + 1, u.indexOf('.'));				
//			}	else{
//				return 'unable to detect account name';		
//			}
//		}
		
		public static function getRepositoryName(u:String):String
		{
			return u.substr(u.lastIndexOf('/') + 1).substr(0, -4);
		}
		
		private static function getRepositoryHomePage(u:String):String
		{
			if (getAccountType(u) == HostingAccount.GITHUB){
				return 'https://github.com/'+getAccountName(u)+'/'+getRepositoryName(u);
			}	else if (getAccountType(u) == HostingAccount.BEANSTALK){
				return 'https://'+getAccountName(u)+'.beanstalkapp.com/'+getRepositoryName(u);
			}	else{
				return 'unable to detect account homepage';		
			}
		}
		
	}
	
}
