package model.proxies.remote.repo {

	import model.vo.BookmarkRemote;
	
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
		
		public function syncRemotes(v:Vector.<BookmarkRemote>):void
		{
			_sync.syncRemotes(v);
		}
		
	}
	
}
