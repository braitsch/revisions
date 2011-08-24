package model.vo {

	import model.remote.HostingAccount;

	public class BookmarkRemote {

		private var _name		:String; // ex. github-revisions-source //
		private var _ssh		:String;
		private var _type		:String;
		private var _acctName	:String;
		private var _repoName	:String;
		private var _branches	:Array = [];

		public function BookmarkRemote(name:String, url:String)
		{
			_name = name.toLowerCase();
			inspectURL(url);
		}		
		
		public function get ssh()			:String { return _ssh; }
		public function get name()			:String { return _name; }
		public function get type()			:String { return _type; }	
		public function get acctName()		:String { return _acctName; }	
		public function get repoName()		:String { return _repoName; }
		
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
		
		public static function inspectURL(u:String):Object
		{
			var o:Object = {};
			if (u.indexOf('@github.com') != -1){	
				o.acctType = HostingAccount.GITHUB;
				o.acctName = getAccountName(u);
			}	else if (u.indexOf('.beanstalkapp.com:/') != -1){
				o.acctType = HostingAccount.BEANSTALK;
				o.acctName = u.substring(u.indexOf('@') + 1, u.indexOf('.'));
			}
			o.repoName = u.substr(u.lastIndexOf('/') + 1);
			return o;	
		}
		
		private static function getAccountName(u:String):String
		{
			if (u.indexOf('git@github.com') != -1 ){
				return u.substring(u.indexOf(':') + 1, u.indexOf('/'));
			}	else if (u.indexOf('https://') != -1 && u.indexOf('@github.com') != -1 ){
				return u.substring(u.indexOf('/') + 2, u.indexOf('@'));
			}	else{
				return 'unable to detect account name';		
			}
		}	

	}
	
}
