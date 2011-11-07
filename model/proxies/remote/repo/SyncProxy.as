package model.proxies.remote.repo {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;

	public class SyncProxy extends GitProxy {

		public function pushBranch(r:Repository, loader:Boolean = true):void
		{
			if (super.working) return;
			var a:Array = [AppModel.branch.name, AppModel.bookmark.gitdir, AppModel.bookmark.worktree];
			super.request = new GitRequest(BashMethods.PUSH_BRANCH, r, a);
			AppModel.showLoader('Syncing With Your '+StringUtils.capitalize(r.acctType) + ' Account');
		}
		
		public function fetchRemote():void
		{
			if (super.working) return;
			var a:Array = [AppModel.bookmark.gitdir, AppModel.bookmark.worktree];
			super.request = new GitRequest(BashMethods.GET_REMOTE_FILES, AppModel.repository, a);
		}
		
		override protected function onProcessSuccess(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.PUSH_BRANCH :
					onBranchPushed();
				break;
				case BashMethods.GET_REMOTE_FILES :
				break;
			}
			super.onProcessSuccess(e);
		}

		private function onBranchPushed():void
		{
			AppModel.hideLoader();
			AppModel.branch.remoteStatus = 0;
			AppModel.dispatch(AppEvent.BRANCH_PUSHED);	
		}
		
	}
	
}
