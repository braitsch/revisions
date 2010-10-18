package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	import view.bookmarks.Bookmark;

	public class BranchProxy extends NativeProcessProxy{

		private static var _index		:uint = 0;
		private static var _queue		:Vector.<Bookmark>;
		private static var _bookmark	:Bookmark;

		public function BranchProxy() 
		{	
			super.executable = 'Branch.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}	
		
		public function getBranchesOfBookmarkQueue(v:Vector.<Bookmark>):void
		{
			_queue = v;
			getBranchesOfBookmark(_queue[_index]);			
		}

		public function getBranchesOfBookmark(b:Bookmark):void
		{
			_bookmark = b;
			trace("BranchProxy.getBranchesOfBookmark(b) > ", b.label);
			super.directory = b.local;
			super.call(Vector.<String>([BashMethods.GET_BRANCHES]));			
		}
		
		public function addBranch($name:String):void
		{
//			trace("BranchProxy.addBranch($new)", $name, AppModel.bookmark.previous.name);
//			super.call(Vector.<String>([BashMethods.ADD_BRANCH, $name, AppModel.bookmark.previous.name]));
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.GET_BRANCHES:
					var ok:Boolean = _bookmark.attachBranches(e.data.result.split(/[\n\r\t]/g));
					if (ok == true){
						onBranchesValidate();
					}	else{
						dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_DETACHED, _bookmark));
					}
				break;		
			}
		}
		
		private function onBranchesValidate():void
		{
			if (_queue == null){
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCHES_READ));
			}	else{
				if (++_index < _queue.length){
					getBranchesOfBookmark(_queue[_index]);	
				}	else{
					_queue = null;
					dispatchEvent(new RepositoryEvent(RepositoryEvent.QUEUE_BRANCHES_READ));
				}
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("BranchProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}	
		
	}
	
}
