package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.GitProxy;
	import model.proxies.remote.base.GitRequest;
	import model.vo.Branch;
	import model.vo.Repository;
	import system.BashMethods;

	public class SyncProxy extends GitProxy {

		private static var _branch		:Branch;
		private static var _remote		:Repository;

		public function syncBranches(b:Branch, r:Repository):void
		{
			_branch = b; _remote = r;
			if (_branch.remoteStatus < 0){
				// need to merge first
			}	else{
				pushBranch();
			}
		}
		
		private function pushBranch():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.request = new GitRequest(BashMethods.PUSH_BRANCH, _remote.url, [_branch.name]);
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.PUSH_BRANCH :
					dispatchSyncComplete();
				break;
			}
		}

		private function dispatchSyncComplete():void
		{
			_branch.remoteStatus = 0;
			trace("SyncProxy.dispatchSyncComplete()");
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
		}
		
	}
	
}
