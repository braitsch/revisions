package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;
	import system.BashMethods;
	import system.StringUtils;

	public class SyncProxy extends GitProxy {

		public function pushBranch(r:Repository):void
		{
			if (super.working) return;
			var a:Array = [AppModel.branch.name, AppModel.bookmark.gitdir, AppModel.bookmark.worktree];
			super.request = new GitRequest(BashMethods.PUSH_BRANCH, r, a);
			AppModel.showLoader('Syncing With Your '+StringUtils.capitalize(r.acctType) + ' Account');
		}
		
		public function pushAndTrack(r:Repository):void
		{
			var a:Array = [AppModel.branch.name, AppModel.bookmark.gitdir, AppModel.bookmark.worktree];
			super.request = new GitRequest(BashMethods.PUSH_AND_TRACK, r, a);
		}
		
		public function fetchRepository():void
		{
			if (super.working || isLoggedIn() == false) return;
			var a:Array = [AppModel.bookmark.gitdir, AppModel.bookmark.worktree];
			super.request = new GitRequest(BashMethods.GET_REMOTE_FILES, AppModel.repository, a);
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.PUSH_BRANCH :
					AppModel.hideLoader();
					AppModel.branch.remoteStatus = 0;
					AppModel.dispatch(AppEvent.BRANCH_SYNCED);
				break;
				case BashMethods.PUSH_AND_TRACK :
					AppModel.hideLoader();
					AppModel.dispatch(AppEvent.BRANCH_PUSHED);
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
