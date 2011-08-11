package model.proxies.remote {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.db.AppSettings;
	import model.vo.Remote;
	import system.BashMethods;
	
	public class RemoteProxy extends NativeProcessProxy {
		
		private static var _index		:uint;
		private static var _remotes		:Vector.<Remote>;

		private static var _remote		:Remote;
		private static var _remoteURL	:String;
		private static var _prompt		:Boolean;
		
		public function RemoteProxy()
		{
			super.executable = 'Remote.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function cloneRemoteRepository(url:String, loc:String):void
		{
			super.call(Vector.<String>([BashMethods.CLONE_REPOSITORY, url, loc]));
		}
		
		public function createRemoteRepository(name:String, desc:String, publik:Boolean):void
		{
			super.call(Vector.<String>([BashMethods.ADD_REPOSITORY, name, desc, publik]));
		}		
		
		public function syncRemotes(v:Vector.<Remote>):void
		{
			_index = 0; _remotes = v; syncNextRemote();
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
			trace("RemoteProxy -- syncing remote "+(_index+1));
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
		
		private function addRemote(r:Remote):void
		{
			_remote = r;
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.defaultURL]));
		}		
		
		private function pullRemote():void
		{
			trace("Attempting.pullRemote() -- ", _remoteURL);
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _remoteURL, AppModel.branch.name]));
		}
		
		private function pushRemote():void
		{
			trace("Attempting.pushRemote() -- ", _remoteURL);
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remoteURL, AppModel.branch.name]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method;
			var r:String = e.data.result;
			if (checkForErrors(r)) return;
			trace("RemoteProxy.onProcessComplete(e)", m, r);
			switch(e.data.method){
				case BashMethods.ADD_REPOSITORY : 
					onRepositoryCreated(r);
				break;					
				case BashMethods.ADD_REMOTE : 
					onAddRemoteComplete(r);
				break;	
				case BashMethods.PULL_REMOTE : 
					pushRemote();
				break;	
				case BashMethods.PUSH_REMOTE : 
					onSyncComplete();
				break;	
			}
		}

	//TODO
		private function onRepositoryCreated(s:String):void
		{
	//		AppModel.proxies.ghRemote.addRemote(new Remote(_name, e.data as String));
		}
		
	//TODO	
		private function onAddRemoteComplete(s:String):void
		{
		// if no errors //			
			pushRemote();
			AppModel.bookmark.addRemote(_remote);			
		}
		
		private function checkForErrors(s:String):Boolean
		{
			var f:Boolean;
			if (hasString(s, 'The requested URL returned error: 403')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));
			}	else if (hasString(s, 'Permission denied (publickey)')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));
			}	else if (hasString(s, 'Authentication failed')){
				f = true;
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));				
			}	else if (hasString(s, 'Couldn\'t resolve host')){
				f = true;
				dispatchAlert('Could not connect to server, did you enter the URL correctly?');
			}	else if (hasString(s, 'fatal: The remote end hung up unexpectedly')){
				f = true;
				dispatchAlert('Whoops! Connection attempt failed, please check your internetz.');
			}	else if (hasString(s, 'fatal:')){
				f = true;
				dispatchAlert('Eek, not sure what just happened, here are the details : '+s);
			}
			return f;
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }
		
		private function onSyncComplete():void
		{
			_prompt = true;
			_remotes.splice(_index, 1);
			if (_remotes.length){
				syncNextRemote();
			}	else{
				trace("RemoteProxy -- all remotes sunk! ");				
				dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			}
		}
		
	// dispatch messages //	
		
		private function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}	
		
		private function dispatchConfirmPushNewBranch():void
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" is not currently being tracked by your '+_remote.type+' repository: "'+_remote.realName+'".';
				m+= '\nAre you sure you want to continue?';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_CONFIRM, {target:this, message:m}));			
		}			

	}
	
}
