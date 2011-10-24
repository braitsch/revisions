package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;

	public class SyncProxy extends GitProxy {

		private static var _repository	:Repository;
		
		public function set repository(r:Repository):void
		{
			_repository = r;			
		}		
		
		public function pushBranch():void
		{
			if (super.working) return;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.request = new GitRequest(BashMethods.PUSH_BRANCH, _repository.url, [AppModel.branch.name]);
			AppModel.showLoader('Syncing With Your '+StringUtils.capitalize(Repository.getAccountType(_repository.url))+' Account');
		}
		
		public function fetchRepository():void
		{
			if (super.working || isLoggedIn() == false) return;
			super.appendArgs([AppModel.bookmark.gitdir, AppModel.bookmark.worktree]);
			super.request = new GitRequest(BashMethods.GET_REMOTE_FILES, AppModel.bookmark.remote.url);
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.PUSH_BRANCH :
					AppModel.hideLoader();
					AppModel.branch.remoteStatus = 0;
					AppModel.dispatch(AppEvent.BRANCH_SYNCED);
				break;
				case BashMethods.GET_REMOTE_FILES :
				break;
			}
		}
		
		private function isLoggedIn():Boolean
		{
			var at:String = Repository.getAccountType(AppModel.bookmark.remote.url);
			if (at == HostingAccount.GITHUB && Hosts.github.loggedIn){
				return true;
			}	else if (at == HostingAccount.BEANSTALK && Hosts.beanstalk.loggedIn){
				return true;
			}	else{
				return false;
			}
		}		

	}
	
}
