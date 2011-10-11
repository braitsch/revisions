package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import system.BashMethods;
	import view.windows.modals.system.Debug;

	public class BkmkReader extends NativeProcessQueue {

		private static var _bookmark	:Bookmark;

		public function BkmkReader() 
		{	
			super.executable = 'BkmkReader.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function getRepositoryInfo(b:Bookmark):void
		{
			_bookmark = b;
			super.appendArgs([_bookmark.gitdir, _bookmark.worktree]);
		//	trace('_bookmark.gitdir: ' + (_bookmark.gitdir));
		//	trace('_bookmark.worktree: ' + (_bookmark.worktree));
			super.queue = [	Vector.<String>([BashMethods.GET_REMOTES]),
							Vector.<String>([BashMethods.GET_LOCAL_BRANCHES]),
							Vector.<String>([BashMethods.GET_REMOTE_BRANCHES])];
		}

		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			onRepositoryInfo(e.data as Array);
		}
		
		private function onRepositoryInfo(a:Array):void
		{
		// strip the method names off the result array //	
			for (var i:int = 0; i < 3; i++) a[i] = a[i].result.split(/[\n\r\t]/g);
			_bookmark.addRemotes(a[0]);
			_bookmark.addLocalBranches(a[1]);
			_bookmark.addRemoteBranches(a[2]);
			AppModel.dispatch(AppEvent.REPOSITORY_READY);
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'RepoReader.onProcessFailure(e)';
			AppModel.alert(new Debug(e.data));
		}
		
	}
	
}
