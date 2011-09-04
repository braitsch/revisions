package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.base.GitProxy;
	import model.proxies.remote.base.GitRequest;
	import model.vo.Bookmark;
	import model.vo.BookmarkRemote;
	import system.BashMethods;

	public class SendProxy extends GitProxy {

		private static var _bkmk	:Bookmark;
		private static var _acct	:ApiProxy;
		private static var _remote	:BookmarkRemote;

		public function addBkmkToAccount(o:Object):void
		{
			_bkmk = o.bkmk;
			_acct = o.acct;
			_acct.makeNewRemoteRepository(o);
			_acct.addEventListener(AppEvent.REPOSITORY_CREATED, onRepositoryCreated);
		}
		
		private function onRepositoryCreated(e:AppEvent):void 
		{
			_remote = e.data as BookmarkRemote;
			super.startTimer();
			super.directory = _bkmk.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.url]));
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.ADD_REMOTE :
					onRemoteAddedToBookmark();
				break;
				case BashMethods.PUSH_REMOTE :
					onBookmarkPushedToAccount();
				break;
			}
		}
		
		private function onRemoteAddedToBookmark():void
		{
			_bkmk.addRemote(_remote);
			super.request = new GitRequest(BashMethods.PUSH_REMOTE, _remote.url, [_bkmk.branch.name]);			
		}
		
		private function onBookmarkPushedToAccount():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.BKMK_ADDED_TO_ACCOUNT, _remote));
		}		

	}
	
}
