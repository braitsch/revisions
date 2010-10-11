package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;

	public class BranchEditor extends EventDispatcher {
		
		private static var _proxy		:NativeProcessProxy;
		private static var _index		:uint = 0;
		private static var _bookmark	:Bookmark;		
		public function BranchEditor()
		{
			_proxy = new NativeProcessProxy();	
			_proxy.executable = 'Branch.sh';
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);	
		}
		
		public function getBranchesOfBookmarks():void 
		{
			trace("BranchEditor.getBranchesOfBookmarks()");	
			_bookmark = AppModel.bookmarks[_index] as Bookmark;
			_proxy.directory = _bookmark.local;
			_proxy.call(Vector.<String>([BashMethods.GET_BRANCHES]));			
		}		
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.GET_BRANCHES: 
					_bookmark.branches = e.data.result.split(/[\n\r\t]/g);
					if (++_index < AppModel.bookmarks.length){
						getBranchesOfBookmarks();
					}	else{
						trace("BranchEditor.onProcessComplete(e)");
						dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY));
					}
				break;		
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("BranchEditor.onProcessFailure(e)");
		}			

	}
	
}
