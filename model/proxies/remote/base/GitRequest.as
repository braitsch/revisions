package model.proxies.remote.base {

	public class GitRequest {

		public var method	:String;
		public var url		:String;
		public var args		:Array;

		public function GitRequest(m:String, u:String, a:Array)
		{
			method = m; url	= u; args = a;
		}
		
	}
	
}
