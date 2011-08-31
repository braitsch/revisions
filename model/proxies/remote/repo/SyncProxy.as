package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.GitProxy;
	import model.proxies.remote.base.GitRequest;
	import model.vo.BookmarkRemote;
	import system.AppSettings;
	import system.BashMethods;

	public class SyncProxy extends GitProxy {

		private static var _remote		:BookmarkRemote;
		private static var _prompt		:Boolean;
		private static var _remotes		:Vector.<BookmarkRemote>;

		public function syncRemotes(v:Vector.<BookmarkRemote>):void
		{
			_remotes = v.concat();
			trace('_remotes: ' + (_remotes.length));
			syncNextRemote();			
		}
		
		private function syncNextRemote():void
		{
			_remote = _remotes[0];
			trace("SyncProxy.syncNextRemote()", _remote.url);
			pullRemote();
		}
		
		private function pullRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.request = new GitRequest(BashMethods.PULL_REMOTE, _remote.url, [AppModel.branch.name]);
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.request = new GitRequest(BashMethods.PUSH_REMOTE, _remote.url, [AppModel.branch.name]);
		}
		
		public function onConfirm(b:Boolean):void
		{
			_prompt = b;
			_prompt ? onSyncComplete() : pushRemote();
		}		
		
		public function skipRemoteSync():void 
		{ 
			onSyncComplete(); 
		}
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.PULL_REMOTE :
					checkRemoteBranchExists();
				break;
				case BashMethods.PUSH_REMOTE :
					onSyncComplete();
				break;
			}
		}

		private function checkRemoteBranchExists():void
		{
			var w:Boolean = AppSettings.getSetting(AppSettings.PROMPT_NEW_REMOTE_BRANCHES);
			if (w == false || _prompt == false){
				pushRemote();
			}	else{
				dispatchConfirmPushNewBranch();
			}			
		}
		
		private function onSyncComplete():void
		{
			_prompt = true;
			if (_remotes) {
				_remotes.splice(0, 1);
				if (_remotes.length){
					syncNextRemote();
				}	else{
					dispatchSyncComplete();
				}
			}	else{
				dispatchSyncComplete();
			}
		}

		private function dispatchSyncComplete():void
		{
			trace("SyncProxy.dispatchSyncComplete()");
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
		}
		
		private function dispatchConfirmPushNewBranch():void
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" is not currently being tracked by your '+_remote.acctType+' repository: "'+_remote.repoName.substr(0, -4)+'".';
				m+= '\nAre you sure you want to continue?';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_CONFIRM, {target:this, message:m}));			
		}							
		
	}
	
}
