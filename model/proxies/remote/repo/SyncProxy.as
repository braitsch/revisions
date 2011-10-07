package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;

	public class SyncProxy extends GitProxy {

		private static var _repository	:Repository;
		
		public function syncBranch(r:Repository):void
		{
			if (AppModel.branch.remoteStatus < 0){
				// need to merge first
			}	else{
				pushBranch(r);
			}
		}
		
		public function pushBranch(r:Repository):void
		{
			_repository = r;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.request = new GitRequest(BashMethods.PUSH_BRANCH, _repository.name, [AppModel.branch.name]);
			AppModel.showLoader('Sending files to '+StringUtils.capitalize(Repository.getAccountType(_repository.url)));
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.PUSH_BRANCH :
					AppModel.branch.remoteStatus = 0;
					AppModel.dispatch(AppEvent.BRANCH_PUSHED);
				break;
			}
			AppModel.hideLoader();
		}

	}
	
}
