package model.proxies {

	import events.NativeProcessEvent;
	import events.BookmarkEvent;
	import model.Bookmark;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	public class BranchProxy extends NativeProcessProxy{

		private static var _bookmark	:Bookmark;

		public function BranchProxy() 
		{	
			super.executable = 'Branch.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function getBranches(b:Bookmark):void
		{
			_bookmark = b;
			super.directory = b.worktree;
			super.call(Vector.<String>([BashMethods.GET_BRANCHES, _bookmark.gitdir]));		}
		
		public function getStashList():void
		{
			super.call(Vector.<String>([BashMethods.GET_STASH_LIST, _bookmark.gitdir]));	
		}
		
	// response handlers //
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
	//		trace("BranchProxy.onProcessComplete(e)", 'method = '+e.data.method, 'result = '+e.data.result);			
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.GET_BRANCHES :
					_bookmark.attachBranches(e.data.result.split(/[\n\r\t]/g));
					dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCHES_READ));
				break;
				case BashMethods.GET_STASH_LIST :
					_bookmark.stash = e.data.result.split(/[\n\r\t]/g);
					dispatchEvent(new BookmarkEvent(BookmarkEvent.STASH_LIST_READ));
				break;
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("BranchProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}	
		
	}
	
}
