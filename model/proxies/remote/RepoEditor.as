package model.proxies.remote {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.db.AppSettings;
	import model.vo.Remote;
	import system.BashMethods;
	import system.StringUtils;
	import flash.filesystem.File;
	
	public class RepoEditor extends RemoteProxy {
		
		private static var _index		:uint;
		private static var _remotes		:Vector.<Remote>;

		private static var _remote		:Remote;
		private static var _remoteURL	:String;
		private static var _prompt		:Boolean;
		
		public function RepoEditor()
		{
			super.executable = 'RepoEditor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function clone(url:String, loc:String):void
		{
			super.call(Vector.<String>([BashMethods.CLONE_REPOSITORY, url, loc]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Cloning Remote Repository'}));
		}
		
		public function commit($msg:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.COMMIT, $msg]));
		}
		
		public function trackFile($file:File):void
		{
			super.directory = AppModel.bookmark.gitdir;			
			super.call(Vector.<String>([BashMethods.TRACK_FILE, $file.nativePath]));
		}
		
		public function unTrackFile($file:File):void
		{
			super.directory = AppModel.bookmark.gitdir;			
			super.call(Vector.<String>([BashMethods.UNTRACK_FILE, $file.nativePath]));
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
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method;
			if (hasStringErrors(e.data.result)) return;
			trace("RemoteProxy.onProcessComplete(e)", m, e.data.result);
			switch(e.data.method){
				case BashMethods.CLONE_REPOSITORY :
					dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
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
				case BashMethods.COMMIT : 
					AppModel.branch.modified = [[], []];
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_COMPLETE));
				break;
				case BashMethods.TRACK_FILE : 
				break;
				case BashMethods.UNTRACK_FILE : 
				break;						
			}
		}

		private function onAddRemoteComplete():void
		{	
			pushRemote();
			AppModel.bookmark.addRemote(_remote);			
		}
		
		private function hasStringErrors(s:String):Boolean
		{
			var f:Boolean;
		// TODO if it was an ssh url that failed, attempt to generate a user/pass https url before prompting user for credentials
			if (hasString(s, 'The requested URL returned error: 403')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));
			}	else if (hasString(s, 'Permission denied (publickey)')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));
			}	else if (hasString(s, 'ERROR: Permission')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));						
			}	else if (hasString(s, 'Authentication failed')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));				
			}	else if (hasString(s, 'Couldn\'t resolve host')){
				f = true;
				dispatchAlert('Could not connect to server, did you enter the URL correctly?');
			}	else if (hasString(s, 'does not exist')){
				f = true;
				dispatchAlert('Could not connect to server, did you enter the URL correctly?');
			}	else if (hasString(s, 'doesn\'t exist. Did you enter it correctly?')){
				f = true;
				dispatchAlert('Could not find that repository, did you enter the URL correctly?');
			}	else if (hasString(s, 'fatal: The remote end hung up unexpectedly')){
				f = true;
				dispatchAlert('Whoops! Connection attempt failed, please check your internetz.');
			}	else if (hasString(s, 'fatal:')){
				f = true;
				dispatchAlert('Eek, not sure what just happened, here are the details : '+s);
			}
			if (f) AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));			
			return f;
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }
		
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
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
