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
		
//		private static var _connectionErrors	:Array = [	'fatal: unable to connect a socket',
//															'fatal: The remote end hung up unexpectedly'];		
		
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
		
		private function syncNextRemote():void
		{
			_remote = _remotes[_index];
			_remoteURL = _remote.defaultURL;
			checkToPushOrPull();
	//		dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));
		}
		
		private function checkToPushOrPull():void
		{
			if (_remote.hasBranch(AppModel.branch.name)){
				pullRemote();				
			}	else{
				var w:Boolean = AppSettings.getSetting(AppSettings.PROMPT_NEW_REMOTE_BRANCHES);
				if (w == false){
					pushRemote();
				}	else{
					dispatchConfirm();
				}
			}			
		}
		
		public function onConfirm(b:Boolean):void
		{
			b ? onSyncComplete() : pushRemote();
		}		
		
		public function skipRemoteSync():void
		{
			onSyncComplete();
		}
		
		public function attemptManualHttpsSync(url:String):void
		{
			checkToPushOrPull();
		}
		
		private function addRemote(r:Remote):void
		{
			_remote = r;
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.defaultURL]));
		}		
		
		private function pullRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _remoteURL, AppModel.branch.name]));
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remoteURL, AppModel.branch.name]));
		}
		
	// when pushing / pulling  
	// always attempt over ssh if an ssh url exists //
	// if ssh fails, attempt over https if we have an https url
	// if no https url or https fails, prompt user for https user/pass				
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method;
			var r:String = e.data.result;
			if (checkForErrors(m, r)) return;
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
		
		private function checkForErrors(m:String, s:String):Boolean
		{
			var msg:String;
			if (hasString(s, 'The requested URL returned error: 403')){
				msg = 'RemoteProxy.noErrors(s) -- username/pass failed';
			}	else if (hasString(s, "Couldn't resolve host")){
				msg = 'Host URL error';
			}	else if (hasString(s, 'fatal:')){
				msg = 'Some other error occurred, check the URL';
			}
			if (msg) trace(m, 'failed ::', msg);
			return msg == null;
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }
		
		private function onSyncComplete():void
		{
			_remotes.splice(_index, 1);
			if (_remotes.length){
				syncNextRemote();
			}	else{
				dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			}
		}
		
	// dispatch messages //	
		
		private function dispatchDebug(o:Object):void
		{
			o.source = 'RemoteProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));
		}	
		
		private function dispatchConfirm():void
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" is not currently being tracked by your '+_remote.type+' repository: "'+_remote.realName+'".';
				m+= '\nAre you sure you want to continue?';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_CONFIRM, {target:this, message:m}));			
		}			

	}
	
}
