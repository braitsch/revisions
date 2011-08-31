package model.proxies.remote.repo {

	import model.proxies.remote.base.GitRequest;
	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.GitProxy;
	import model.vo.BookmarkRemote;
	import system.AppSettings;
	import system.BashMethods;
	import system.StringUtils;

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
			checkToPushOrPull();
		}
		
		private function checkToPushOrPull():void
		{
			if (_remote.hasBranch(AppModel.branch.name)){
				pullRemote();				
			}	else{
				var w:Boolean = AppSettings.getSetting(AppSettings.PROMPT_NEW_REMOTE_BRANCHES);
				if (w == false || _prompt == false){
					pushRemote();
				}	else{
					dispatchConfirmPushNewBranch();
				}
			}			
		}
		
		private function pullRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.request = new GitRequest(BashMethods.PULL_REMOTE, _remote.url, [AppModel.branch.name]);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Fetching files from '+StringUtils.capitalize(_remote.acctType)}));
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.request = new GitRequest(BashMethods.PUSH_REMOTE, _remote.url, [AppModel.branch.name]);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Sending files to '+StringUtils.capitalize(_remote.acctType)}));
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
			trace("SyncProxy.onProcessSuccess(m)", m);
			switch(m){
				case BashMethods.PULL_REMOTE :
					pushRemote();
				break;
				case BashMethods.PUSH_REMOTE :
					onSyncComplete();
				break;
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
