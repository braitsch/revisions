package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;

	public class SendProxy {

		private static var _proxy	:ApiProxy;
		private static var _account	:HostingAccount;

		public function uploadBookmark(o:Object):void
		{
			_account = o.acct;
			_proxy = _account.type == HostingAccount.GITHUB ? Hosts.github.api : Hosts.beanstalk.api;
			_proxy.addRepository(o);
			_proxy.addEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
		}

		private function onRepositoryCreated(e:AppEvent):void
		{
			_proxy.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
			AppModel.proxies.sync.pushAndTrack(_account.repository);
			AppModel.engine.addEventListener(AppEvent.BRANCH_PUSHED, onBranchPushed);			
		}
		
		private function onBranchPushed(e:AppEvent):void 
		{
			AppModel.proxies.editor.addRemote(_account.repository);
			AppModel.engine.addEventListener(AppEvent.REMOTE_ADDED, onRemoteAdded);
			AppModel.engine.removeEventListener(AppEvent.BRANCH_PUSHED, onBranchPushed);
		}

		private function onRemoteAdded(e:AppEvent):void
		{
			_account.repository.addBranch(AppModel.branch.name);
			AppModel.dispatch(AppEvent.BKMK_ADDED_TO_ACCOUNT);
			AppModel.engine.removeEventListener(AppEvent.REMOTE_ADDED, onBranchPushed);
		}
		
	}
	
}
