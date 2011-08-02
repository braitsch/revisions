package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessQueue;
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
			super.queue = [	Vector.<String>([BashMethods.GET_BRANCHES, _bookmark.gitdir]),
							Vector.<String>([BashMethods.GET_REMOTES, _bookmark.gitdir]),
							Vector.<String>([BashMethods.GET_STASH_LIST, _bookmark.gitdir])];
		}

	// response handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
		// strip the method names off the result array //	
			for (var i:int = 0; i < a.length; i++) a[i] = a[i].result.split(/[\n\r\t]/g);
			_bookmark.attachBranches(a[0]);
			if (a[1] != '') _bookmark.parseRemotes(a[1]);
			_bookmark.stash = a[2];
			dispatchEvent(new AppEvent(AppEvent.REPOSITORY_READY));
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'BranchProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, e.data));
		}
		
	}
	
}
