package model.proxies.remote {

	import system.StringUtils;
	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.db.AppSettings;
	import model.remote.RemoteAccount;
	import model.vo.Remote;
	import system.BashMethods;
	import com.adobe.serialization.json.JSONDecoder;
	
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
		
		private function addRemoteToLocalRepository():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.defaultURL]));
		}		
		
		private function pullRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _remoteURL, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Fetching files from '+StringUtils.capitalize(_remote.type)));
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remoteURL, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Sending files to '+StringUtils.capitalize(_remote.type)));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method;
			if (hasStringErrors(e.data.result)) return;
			trace("RemoteProxy.onProcessComplete(e)", m, e.data.result);
			switch(e.data.method){
				case BashMethods.ADD_REPOSITORY : 
					onRepositoryCreated(e.data.result);
				break;					
				case BashMethods.CLONE_REPOSITORY :
					dispatchEvent(new AppEvent(AppEvent.CLONE_COMPLETE));
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

		private function onRepositoryCreated(s:String):void
		{
			var o:Object = getResultObject(s);
			if (hasJSONErrors(o) == false){
				_remote = new Remote(RemoteAccount.GITHUB+'-'+o.name, o.ssh_url);
				_remoteURL = _remote.defaultURL;
				addRemoteToLocalRepository();
				dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, o));
			}
		}
		
		private function onAddRemoteComplete():void
		{	
			pushRemote();
			AppModel.bookmark.addRemote(_remote);			
		}
		
		private function getResultObject(s:String):Object
		{
		// strip off any post headers we receive before parsing json //	
			if (s.indexOf('{') != -1){
				return new JSONDecoder(s.substr(s.indexOf('{')), false).getValue();
			}	else{
				return {result:s};
			}
		}
		
		private function hasJSONErrors(o:Object):Boolean
		{
			var f:Boolean;
			if (o.message == null) return false;
			if (o.errors[0].message == 'name is already taken'){
				f = true;
				dispatchAlert('That repository name is already taken, please choose something else');
			} else if (o.errors[0].message == 'name can\'t be private. You are over your quota.'){
				f = true;
				dispatchAlert('Whoops! Looks like you\'re all out of private repositories, consider making this one public or upgrade your account.');
			}
			if (f) AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			return f;			
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
