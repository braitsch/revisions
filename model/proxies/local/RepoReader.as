package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessQueue;
	import model.vo.Bookmark;
	import system.BashMethods;

	public class RepoReader extends NativeProcessQueue {

		private static var _bookmark	:Bookmark;

		public function RepoReader() 
		{	
			super.executable = 'RepoReader.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function getRepositoryInfo(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = _bookmark.worktree;
			super.queue = [	Vector.<String>([BashMethods.GET_STASH, _bookmark.gitdir]),
							Vector.<String>([BashMethods.GET_REMOTES, _bookmark.gitdir]),
							Vector.<String>([BashMethods.GET_LOCAL_BRANCHES, _bookmark.gitdir]),
							Vector.<String>([BashMethods.GET_REMOTE_BRANCHES, _bookmark.gitdir])];
		}

		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
		// strip the method names off the result array //	
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result.split(/[\n\r\t]/g);
			_bookmark.addStash(a[0]);
			_bookmark.addRemotes(a[1]);
			_bookmark.addLocalBranches(a[2]);
			_bookmark.addRemoteBranches(a[3]);
			dispatchEvent(new AppEvent(AppEvent.REPOSITORY_READY));
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'BranchProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}
		
	}
	
}
