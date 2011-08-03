package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Branch;
	import model.vo.Remote;
	import system.BashMethods;
	
	public class RemoteProxy extends NativeProcessProxy {
		
		private static var _remote	:Remote;
		
		public function RemoteProxy()
		{
			super.executable = 'Remote.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function addRemote($remote:Remote):void
		{
			_remote = $remote;
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.ADD_REMOTE, _remote.name, _remote.push]));
		}
		
		public function syncWithRemote($remote:Remote):void
		{
			_remote = $remote;
			var b:Branch = AppModel.bookmark.branch;
			var create:Boolean = _remote.hasBranch(b.name);
			trace("RemoteProxy.syncWithRemote($remote)", b.name, create);
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PULL_REMOTE, _remote.name, b.name, create]));						
		}
		
		private function pushToRemote():void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_REMOTE, _remote.name, AppModel.bookmark.branch.name]));
		}				
		
		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
			trace("RemoteProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.ADD_REMOTE : 
					AppModel.bookmark.addRemote(_remote);
					pushToRemote();
				break;	
				case BashMethods.PULL_REMOTE : 
					pushToRemote();
				break;	
				case BashMethods.PUSH_REMOTE : 
					dispatchEvent(new AppEvent(AppEvent.REMOTE_SYNCED));
				break;	
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

	}
	
}
