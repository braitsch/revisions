package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;

	public class SyncProxy extends GitProxy {

		private static var _working		:Boolean;
		private static var _function	:Function;
		private static var _repository	:Repository;
		
		public function set repository(r:Repository):void
		{
			_repository = r;			
		}		
		
		public function pushBranch():void
		{
			if (_working){
				_function = pushBranch;
			}	else{
				_working = true;
				super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
				super.request = new GitRequest(BashMethods.PUSH_BRANCH, _repository.name, [AppModel.branch.name]);
			}
			AppModel.showLoader('Syncing With Your '+StringUtils.capitalize(Repository.getAccountType(_repository.url))+' Account');
		}
		
		public function fetchRepository():void
		{
			if (_working){
				_function = fetchRepository;
			}	else{
				_working = true;
				super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
				super.request = new GitRequest(BashMethods.GET_REMOTE_FILES, AppModel.bookmark.remote.url, []);
			}
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			_working = false;
			switch(m){
				case BashMethods.PUSH_BRANCH :
					AppModel.hideLoader();
					AppModel.branch.remoteStatus = 0;
					AppModel.dispatch(AppEvent.BRANCH_SYNCED);
				break;
				case BashMethods.GET_REMOTE_FILES :
				break;
			}
			if (_function != null) {
				_function(); _function = null;
			}
		}

	}
	
}
