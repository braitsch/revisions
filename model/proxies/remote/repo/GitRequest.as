package model.proxies.remote.repo {

	import model.vo.Repository;

	public class GitRequest {

		public var remote	:Repository;
		public var method	:String;
		public var args		:Array;

		public function GitRequest(m:String, r:Repository, a:Array = null)
		{
			method = m; remote = r; args = a;
		}
		
	}
	
}