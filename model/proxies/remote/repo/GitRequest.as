package model.proxies.remote.repo {

	public class GitRequest {

		public var method	:String;
		public var url		:String;
		public var args		:String = '';

		public function GitRequest(m:String, u:String, a:Array = null)
		{
			method = m; url	= u;
			if (a) args = a.join(', ');
		}
		
	}
	
}