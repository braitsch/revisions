package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Remote;
	import system.BashMethods;
	
	public class RemoteProxy extends NativeProcessProxy {
		
		private static var _index	:uint;
		private static var _remote	:Remote;
		private static var _remotes	:Vector.<Remote>;
		
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
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.push]));
		}
	// called only from SummaryView	
		public function syncRemotes(v:Vector.<Remote>):void
		{
			_index = 0; _remotes = v;
			syncNextRemote();
		}
		
		public function onConfirm(b:Boolean):void
		{
			trace("RemoteProxy.onConfirm(b)", b);
			b ? syncNextRemote(false) : onSyncComplete();
		}
		
		private function syncNextRemote(warn:Boolean = true):void
		{
			_remote = _remotes[_index];
			trace("RemoteProxy.syncNextRemote()", _remote.name);
			if (_remote.hasBranch(AppModel.branch.name)){
				pullRemote();				
			}	else{
				if (!warn){
					pushRemote();
				}	else{
					dispatchConfirm();
				}
			}			
		}
		
		private function pullRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _remote.name, AppModel.branch.name]));
		}
		
		private function pushRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remote.name, AppModel.branch.name]));
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
			var m:String = 'The current branch '+AppModel.branch.name+' is not currently being tracked by the remote account you are about to sync to.';
				m+= 'Are you sure you want to continue?';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_CONFIRM, {target:this, message:m}));			
		}			

	}
	
}
