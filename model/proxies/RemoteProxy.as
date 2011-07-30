package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Remote;
	import system.BashMethods;
	
	public class RemoteProxy extends NativeProcessProxy {
		
		private static var _remote:Remote;
		
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
		
		public function pushToRemote($remote:Remote, $branch:String):void
		{
			_remote = $remote;			
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.PUSH_TO_REMOTE, _remote.name, $branch]));
		}			

		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
		//	trace("RemoteProxy.onProcessComplete(e)", e.data.method, e.data.result);
		// TODO need to pass in a real branch var instead of 'master'
			switch(e.data.method){
				case BashMethods.ADD_REMOTE : 
					pushToRemote(_remote, 'master');
				break;	
				case BashMethods.PUSH_TO_REMOTE : 
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
