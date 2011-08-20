package model.proxies.remote.repo {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.GitNetworkProxy;
	import model.vo.Remote;
	import system.AppSettings;
	import system.BashMethods;
	import system.StringUtils;
	
	public class RepoRemote extends GitNetworkProxy {
		
		private static var _index		:uint;
		private static var _remotes		:Vector.<Remote>;

		private static var _remote		:Remote;
		private static var _remoteURL	:String;
		private static var _prompt		:Boolean;
		
		public function RepoRemote()
		{
			super.executable = 'RepoRemote.sh';
		}
		
		public function clone(url:String, loc:String):void
		{
			super.call(Vector.<String>([BashMethods.CLONE, url, loc]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Cloning Remote Repository'}));
		}
		
		public function syncRemotes(v:Vector.<Remote>):void
		{
			_index = 0; _remotes = v; syncNextRemote();
		}
		
		public function addRemoteToLocalRepository(r:Remote):void
		{
			_remote = r; _remoteURL = _remote.defaultURL;
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remoteURL]));
		}			
		
	// callbacks //	
		
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
		
	// private //	
		
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
		
		override protected function onProcessSuccess(m:String):void 
		{
			switch(m){
				case BashMethods.CLONE :
					onCloneComplete();
				break;
				case BashMethods.ADD_REMOTE : 
					onAddRemoteComplete();
				break;	
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
		// here we should check the failed _remoteURL and either autogenerate https
		// or prompt user to enter their credentials manually	
			dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));			
		}
		
		private function onCloneComplete():void
		{
			dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
		}
		
		private function onAddRemoteComplete():void
		{	
			pushRemote();
			AppModel.bookmark.addRemote(_remote);			
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
		
	// dispatch messages //	
		
		private function dispatchConfirmPushNewBranch():void
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" is not currently being tracked by your '+_remote.type+' repository: "'+_remote.repoName.substr(0, -4)+'".';
				m+= '\nAre you sure you want to continue?';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_CONFIRM, {target:this, message:m}));			
		}			

	}
	
}
