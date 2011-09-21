package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.base.GitProxy;
	import model.proxies.remote.base.GitRequest;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;
	import system.BashMethods;

	public class SendProxy extends GitProxy {

		private static var _api		:ApiProxy;
		private static var _acct	:HostingAccount;
		private static var _repo	:Repository;

		public function addBkmkToAccount(o:Object):void
		{
			_acct = o.acct;
			_api = _acct.type == HostingAccount.GITHUB ? Hosts.github.api : Hosts.beanstalk.api;
			_api.addRepository(o);
			_api.addEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
		}
		
		public function rmBkmkFromAccount(r:Repository):void
		{
			_repo = r;
			super.startTimer();
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.KILL_REMOTE, _repo.name]));			
		}
		
		private function onRepositoryCreated(e:AppEvent):void 
		{
			super.startTimer();
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _acct.repository.name, _acct.repository.url]));
			_acct.removeEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.ADD_REMOTE :
					onRemoteAddedToBookmark();
				break;
				case BashMethods.KILL_REMOTE :
					onRemoteRemovedFromBookmark();
				break;				
				case BashMethods.PUSH_REMOTE :
					onBookmarkPushedToAccount();
				break;
			}
		}

		private function onRemoteAddedToBookmark():void
		{
			AppModel.bookmark.addRemote(_acct.repository);
			super.request = new GitRequest(BashMethods.PUSH_REMOTE, _acct.repository.url, [AppModel.branch.name]);			
		}
		
		private function onRemoteRemovedFromBookmark():void
		{
			AppModel.bookmark.killRemote(_repo);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.BKMK_REMOVED_FROM_ACCOUNT));	
		}		
		
		private function onBookmarkPushedToAccount():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.BKMK_ADDED_TO_ACCOUNT));
		}		

	}
	
}
