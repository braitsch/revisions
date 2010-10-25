package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	import model.Bookmark;

	public class BranchProxy extends NativeProcessProxy{

		private static var _bookmark	:Bookmark;

		public function BranchProxy() 
		{	
			super.executable = 'Branch.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function getBranchesOfBookmark(b:Bookmark):void
		{
			trace("BranchProxy.getBranchesOfBookmark(b) > ", b.label);
			_bookmark = b;
			super.directory = b.local;
			super.call(Vector.<String>([BashMethods.GET_BRANCHES]));					}
		
		public function getStashList():void
		{
			super.call(Vector.<String>([BashMethods.GET_STASH_LIST]));			
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.GET_BRANCHES :
					var ok:Boolean = _bookmark.attachBranches(e.data.result.split(/[\n\r\t]/g));
					if (ok == true){
						dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCHES_READ));
					}	else{
						dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_DETACHED, _bookmark));
					}
				break;
				case BashMethods.GET_STASH_LIST :
						_bookmark.stash = e.data.result.split(/[\n\r\t]/g);
						dispatchEvent(new RepositoryEvent(RepositoryEvent.STASH_LIST_READ));
				break;
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("BranchProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}	
		
	}
	
}
