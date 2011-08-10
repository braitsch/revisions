package model.proxies.remote {

	import model.remote.RemoteAccount;
	import model.remote.Accounts;
	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Remote;
	import system.BashMethods;
	
	public class RemoteProxy extends NativeProcessProxy {
		
		private static var _index	:uint;
		private static var _url		:String;
		private static var _remote	:Remote;
		private static var _remotes	:Vector.<Remote>;
		
//		private static var _connectionErrors	:Array = [	'fatal: unable to connect a socket',
//															'fatal: The remote end hung up unexpectedly'];		
		
		public function RemoteProxy()
		{
			super.executable = 'Remote.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
	// called only from RemoRepo //	
		public function addRemote($remote:Remote):void
		{
			_remote = $remote;
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.url]));
		}
		
		public function clone(url:String, loc:String):void
		{
			super.call(Vector.<String>([BashMethods.CLONE_REPOSITORY, url, loc]));
		}
		
		public function addRepository($name:String, $desc:String, $public:Boolean):void
		{
			super.call(Vector.<String>([BashMethods.ADD_REPOSITORY, $name, $desc, $public]));
		}		
		
	// called only from SummaryView	
		public function syncRemotes(v:Vector.<Remote>):void
		{
			_index = 0; _remotes = v;
			syncNextRemote();
		}
		
		public function onConfirm(b:Boolean):void
		{
			b ? syncNextRemote(false) : onSyncComplete();
		}
		
		public function skipRemoteSync():void
		{
			onSyncComplete();
		}
		
		public function attemptSyncOverHTTPS(https:String):void
		{
			_url = https;
			checkToPushOrPull(true);
		}
		
		private function syncNextRemote(warn:Boolean = true):void
		{
			_remote = _remotes[_index];
			_url = getRemoteURL(_remote);
			if (_url != null){
				checkToPushOrPull(warn);
			}	else{
				dispatchEvent(new AppEvent(AppEvent.PROMPT_FOR_REMOTE_PSWD, _remote));
			}
		}
		
		private function checkToPushOrPull(warn:Boolean = true):void
		{
			if (_remote.hasBranch(AppModel.branch.name)){
				pullRemote();				
			}	else{
				warn ? dispatchConfirm() : pushRemote();
			}			
		}
		
		private function pullRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _url, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Receiving Files'));
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _url, AppModel.branch.name]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, 'Sending Files'));
		}				
		
		private function getRemoteURL(r:Remote):String
		{
			if (r.type == RemoteAccount.GITHUB){
				return Accounts.github.getRemoteURL(r);
			}	else if (r.type == RemoteAccount.BEANSTALK){
			// coming soon	
			}
			return r.name;
		}
		
		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
			trace("RemoteProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.ADD_REMOTE : 
					pushRemote();
					AppModel.bookmark.addRemote(_remote);
				break;	
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
			_remotes.splice(_index, 1);
			if (_remotes.length){
				_index++; syncNextRemote();
			}	else{
				dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			}
		}		
		
		private function handleProcessFailure(e:NativeProcessEvent):void
		{
			dispatchDebug(e.data);
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}			
		
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
