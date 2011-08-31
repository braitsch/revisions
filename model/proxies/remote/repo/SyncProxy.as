package model.proxies.remote.repo {

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
		private static var _lastFunc	:Function;

		public function SyncProxy()
		{
			super.executable = 'RepoRemote.sh';
		}
		
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
		
		private function pullRemote(u:String = null):void
		{
			_lastFunc = pullRemote;
			super.startTimer();
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, u || _remote.url, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Fetching files from '+StringUtils.capitalize(_remote.acctType)}));
		}
		
		private function pushRemote(u:String = null):void
		{
			_lastFunc = pushRemote;
			super.startTimer();
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, u || _remote.url, AppModel.branch.name]));
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
		
		override protected function onAuthenticationFailure():void
		{
			AppModel.engine.addEventListener(AppEvent.RETRY_REMOTE_REQUEST, onRetryRequest);
			super.inspectURL(_remote.url);
		}

		private function onRetryRequest(e:AppEvent):void
		{
			if (e.data != null) _lastFunc(e.data as String);
			AppModel.engine.removeEventListener(AppEvent.RETRY_REMOTE_REQUEST, onRetryRequest);			
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
