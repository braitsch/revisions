package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Repository;
	import system.BashMethods;

	public class SyncProxy extends GitProxy {

		private static var _repo	:Repository;
		
		public function syncBranch(r:Repository):void
		{
			_repo = r;
			if (AppModel.branch.remoteStatus < 0){
				// need to merge first
			}	else{
				pushBranch();
			}
		}
		
		public function pushBranch():void
		{
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.request = new GitRequest(BashMethods.PUSH_BRANCH, _repo.url, [_repo.name]);
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
			AppModel.branch.remoteStatus = 0;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.BRANCH_PUSHED));
		}				

	}
	
}
