package model.proxies.remote.repo {
	import model.remote.HostingAccount;

	public class GitRequest {

		public var method	:String;
		public var url		:String;
		public var type		:String;
		public var args		:String = '';

		public function GitRequest(m:String, u:String, a:Array = null)
		{
			method = m; url	= u;
			if (a) args = a.join(', ');
			type = u.search('.beanstalkapp.com:/') == -1 ? HostingAccount.GITHUB : HostingAccount.BEANSTALK;
		}
		
	}
	
}