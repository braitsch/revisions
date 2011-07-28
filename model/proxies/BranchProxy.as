package model.proxies {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.vo.Bookmark;
	import system.BashMethods;

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
			super.call(Vector.<String>([BashMethods.GET_BRANCHES, _bookmark.gitdir]));		}
		
		public function getRemotes():void
		{
			super.directory = _bookmark.worktree;			
			super.call(Vector.<String>([BashMethods.GET_REMOTES, _bookmark.gitdir]));	
		}		
		
		public function getStashList():void
		{
			super.directory = _bookmark.worktree;			
			super.call(Vector.<String>([BashMethods.GET_STASH_LIST, _bookmark.gitdir]));	
		}
		
		
	// response handlers //
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
	//		trace("BranchProxy.onProcessComplete(e)", _bookmark.label, 'method = '+e.data.method, 'result = '+e.data.result);			
			var m:String = String(e.data.method);
			var r:Array = e.data.result.split(/[\n\r\t]/g);
			switch(m){
				case BashMethods.GET_BRANCHES :
					_bookmark.attachBranches(r);
					dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCHES_READ));
				break;
				case BashMethods.GET_REMOTES :
					if (r[0] != '') _bookmark.remotes = r;
					dispatchEvent(new BookmarkEvent(BookmarkEvent.REMOTES_READ));
				break;				
				case BashMethods.GET_STASH_LIST :
					_bookmark.stash = r;
					dispatchEvent(new BookmarkEvent(BookmarkEvent.STASH_LIST_READ));
				break;
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'BranchProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}
		
	}
	
}
