package model.proxies.remote.repo {

	import model.AppModel;
	import events.AppEvent;
	import model.proxies.remote.acct.AccountProxy;
	import model.proxies.remote.base.GitProxy;
	import model.vo.Bookmark;
	import model.vo.BookmarkRemote;
	import system.BashMethods;

	public class SendProxy extends GitProxy {

		private static var _bkmk	:Bookmark;
		private static var _acct	:AccountProxy;
		private static var _remote	:BookmarkRemote;

		public function SendProxy()
		{
			super.executable = 'RepoRemote.sh';
		}
		
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
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.defaultURL]));
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			trace("SendProxy.onProcessSuccess(m)", m);
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
			super.startTimer();
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remote.defaultURL, _bkmk.branch.name]));
		}
		
		override public function onNewUserCredentials(user:String, pass:String):void
		{
			super.startTimer();
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remote.buildHttpsURL(user, pass), _bkmk.branch.name]));
		}
		
		override protected function onAuthenticationFailure():void
		{
			super.getNewUserCredentials(this, _remote.acctName, 'Attempt to push bookmark '+_bkmk.label+' failed.');
		}
		
		private function onBookmarkPushedToAccount():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.BKMK_ADDED_TO_ACCOUNT));
		}		

	}
	
}
