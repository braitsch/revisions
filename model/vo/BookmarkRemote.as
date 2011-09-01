package model.vo {

	import model.remote.HostingAccount;

	public class BookmarkRemote {

		private var _name		:String; // ex. github-revisions-source //
		private var _url		:String;
		private var _branches	:Array = [];
		private var _acctType	:String;
		private var _acctName	:String;
		private var _repoName	:String;
		private var _homePage	:String;

		public function BookmarkRemote(name:String, url:String)
		{
			_name = name.toLowerCase(); 
			_url = url;
			_acctType = getAccountType(url);
			_acctName = getAccountName(url);
			_repoName = getRepositoryName(url);
			_homePage = getRepositoryHomePage(url);
		}
		
		public function get url()			:String { return _url; 		}
		public function get name()			:String { return _name; 	}
		public function get acctType()		:String { return _acctType; }	
		public function get acctName()		:String { return _acctName; }	
		public function get repoName()		:String { return _repoName; }
		public function get homePage()		:String { return _homePage; }
		
		public function addBranch(s:String):void
		{
			_branches.push(s);
		}
		
		public function hasBranch(s:String):Boolean
		{
			for (var i:int = 0; i < _branches.length; i++) if (_branches[i] == s) return true;
			return false;
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
			}	else if (u.indexOf('https://') != -1 && u.indexOf('@github.com') != -1 ){
				return u.substring(u.indexOf('/') + 2, u.indexOf('@'));
			}	else if (u.indexOf('.beanstalkapp.com:/') != -1){
				return u.substring(u.indexOf('@') + 1, u.indexOf('.'));				
			}	else{
				return 'unable to detect account name';		
			}
		}
		
		public static function getRepositoryName(u:String):String
		{
			return u.substr(u.lastIndexOf('/') + 1);
		}
		
		private static function getRepositoryHomePage(u:String):String
		{
			if (getAccountType(u) == HostingAccount.GITHUB){
				return 'https://github.com/'+getAccountName(u)+'/'+getRepositoryName(u).substr(0, -4);
			}	else if (getAccountType(u) == HostingAccount.BEANSTALK){
				return 'https://'+getAccountName(u)+'.beanstalkapp.com/'+getRepositoryName(u).substr(0, -4);
			}	else{
				return 'unable to detect account homepage';		
			}
		}
		
		public static function buildHttpsURL(u:String, p:String, a:String, r:String):String
		{
			return 'https://' + u + ':' + p + '@github.com/' + a +'/'+ r;
		}

	}
	
}
