package model.vo {
	import model.remote.RemoteAccount;

	public class Remote {

		private var _name		:String; //TODO can we get rid of this????
		private var _url		:String;
		private var _type		:String;
		private var _acctName	:String;
		private var _repoName	:String;
		private var _branches	:Array = [];

		public function Remote($name:String, $url:String)
		{
			_name = $name; _url = $url;
			detectAccountType();
			detectAccountName();
			_repoName = _url.substr(_url.lastIndexOf('/')+1);
		}

		private function detectAccountType():void
		{
			if (_url.indexOf('github.com') != -1) {
				_type = RemoteAccount.GITHUB;
			}	else if (_url.indexOf('beanstalkapp.com') != -1) {
				_type = RemoteAccount.BEANSTALK;
			}	else {
				_type = RemoteAccount.PRIVATE;
			}
		}
		
		private function detectAccountName():void
		{
			if (_url.indexOf('https://') != -1){
				_acctName = _url.substring(8, _url.indexOf('@'));
			}	else if (_url.indexOf('git@') != -1){
				if (_url.indexOf('github') != -1){
					_acctName = _url.substring(15, _url.indexOf('/'));
				}	else if (_url.indexOf('beanstalk') != -1){
					_acctName = _url.substring(4, _url.indexOf('.'));
				}
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type;
		}	
		
		public function get acctName():String
		{
			return _acctName;
		}	
		
		public function get repoName():String
		{
			return _repoName;
		}						
		
		public function get realName():String
		{
			var rn:String = _name;
			if (_name.indexOf('rvgh-') != -1) rn = _name.substr(5);
			if (_name.indexOf('rvbs-') != -1) rn = _name.substr(5);
			if (_name.indexOf('rvpr-') != -1) rn = _name.substr(5);
			var a:Array = rn.split('-');
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].substr(0, 1).toUpperCase() + a[i].substr(1);
			return a.join(' ');
		}		

		public function get url():String
		{
			return _url;
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

	}
	
}
