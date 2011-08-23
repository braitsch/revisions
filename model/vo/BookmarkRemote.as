package model.vo {

	import model.remote.Hosts;
	import model.remote.HostingAccount;

	public class BookmarkRemote {

		private var _name		:String; // ex. github-revisions-source //
		private var _ssh		:String;
		private var _https		:String;
		private var _type		:String;
		private var _acctName	:String;
		private var _repoName	:String;
		private var _branches	:Array = [];

		public function BookmarkRemote(name:String, url:String)
		{
			_name = name.toLowerCase();
			inspectURL(url);
		}		
		
		public function get name()			:String { return _name; }
		public function get type()			:String { return _type; }	
		public function get acctName()		:String { return _acctName; }	
		public function get repoName()		:String { return _repoName; }
		public function get defaultURL()	:String { return _ssh || this.https; }
		
		public function get https():String
		{
			var a:HostingAccount = Hosts.getAccountByName(_type, _acctName);
			if (a == null) {
				return null;
			}	else{
				return buildHttpsURL(a.user, a.pass);
			}
		}

		public function buildHttpsURL(u:String, p:String):String
		{
			return 'https://' + u + ':' + p + '@github.com/' + u +'/'+ _repoName;
		}
		
		public function addBranch(s:String):void
		{
			_branches.push(s);
		}
		
		public function hasBranch(s:String):Boolean
		{
			for (var i:int = 0; i < _branches.length; i++) if (_branches[i] == s) return true;
			return false;
		}
	
	// private //	
		
		private function inspectURL(s:String):void
		{
			if (s.indexOf('git') == 0){
				parseSSH(s);
			}	else if (s.indexOf('https') == 0){
				parseHTTPS(s);
			}
			_repoName = s.substr(s.lastIndexOf('/') + 1);			
		}
		
		private function parseSSH(s:String):void
		{
			_ssh = s;
			if (s.indexOf('github.com') != -1){
				_type = HostingAccount.GITHUB;
				_acctName = _ssh.substring(15, _ssh.indexOf('/'));
			}	else if (s.indexOf('beanstalkapp.com') != -1){
				_type = HostingAccount.BEANSTALK;
				_acctName = _ssh.substring(4, _ssh.indexOf('.'));
			}			
		}
		
		private function parseHTTPS(s:String):void
		{
			_https = s;
			_type = HostingAccount.GITHUB;
			_acctName = s.substring(8, s.indexOf('@'));			
		}		

	}
	
}
