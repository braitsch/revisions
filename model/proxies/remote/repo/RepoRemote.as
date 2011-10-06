package model.proxies.remote.repo {

	import model.vo.Branch;
	import model.vo.Repository;
	
	public class RepoRemote {
		
		private static var _sync		:SyncProxy = new SyncProxy();
		private static var _send		:SendProxy = new SendProxy();
		private static var _clone		:CloneProxy = new CloneProxy();
		
		public function clone(url:String, loc:String):void
		{
			_clone.clone(url, loc);
		}
		
		public function addBkmkToAccount(o:Object):void
		{
			_send.addBkmkToAccount(o);
		}
		
		public function rmBkmkFromAccount(r:Repository):void
		{
			_send.rmBkmkFromAccount(r);
		}
		
		public function sync(b:Branch, r:Repository):void
		{
			_sync.syncBranches(b, r);
		}
		
	}
	
}
