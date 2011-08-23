package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.GitProxy;
	import model.vo.BookmarkRemote;
	import system.AppSettings;
	import system.BashMethods;
	import system.StringUtils;

	public class SyncProxy extends GitProxy {

		private static var _index		:uint;
		private static var _remote		:BookmarkRemote;
		private static var _prompt		:Boolean;
		private static var _remotes		:Vector.<BookmarkRemote>;
		private static var _remoteURL	:String;

		public function SyncProxy()
		{
			super.executable = 'RepoRemote.sh';
		}
		
		public function syncRemotes(v:Vector.<BookmarkRemote>):void
		{
			_index = 0; _remotes = v.concat(); syncNextRemote();			
		}
		
		private function syncNextRemote():void
		{
			_remote = _remotes[_index];
			_remoteURL = _remote.defaultURL;
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
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _remoteURL, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Fetching files from '+StringUtils.capitalize(_remote.type)}));
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remoteURL, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Sending files to '+StringUtils.capitalize(_remote.type)}));
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
		
		public function attemptManualHttpsSync(u:String, p:String):void
		{
			_remoteURL = _remote.buildHttpsURL(u, p);
			checkToPushOrPull();
		}			
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.CLONE :
				break;
			}
		}			
		
		private function onSyncComplete():void
		{
			_prompt = true;
			if (_remotes) {
				_remotes.splice(_index, 1);
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
			dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
		}
		
		private function dispatchConfirmPushNewBranch():void
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" is not currently being tracked by your '+_remote.type+' repository: "'+_remote.repoName.substr(0, -4)+'".';
				m+= '\nAre you sure you want to continue?';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_CONFIRM, {target:this, message:m}));			
		}							
		
	}
	
}
