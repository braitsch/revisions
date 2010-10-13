package model.git.repo {
	import events.NativeProcessEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.git.bash.BashMethods;

	import view.bookmarks.Bookmark;
	import view.history.HistoryItem;

	public class CheckoutProxy extends NativeProcessProxy {

		public function CheckoutProxy()
		{
			super.executable = 'Editor.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);			
		}
		
		public function set bookmark(b:Bookmark):void 
		{
			super.directory = b.local;
		}
		
		public function checkout(n:HistoryItem):void 
		{
			var bkmk:Bookmark = AppModel.bookmark;
			trace("RepositoryHistory.checkout(sha1, index, mod)", n.sha1, n.name, n.index, 'mod = ',bkmk.branch.modified);
			
		// record where we are before we detach the head //	
			if (bkmk.branch.name != Bookmark.DETACH) bkmk.previous = bkmk.branch;
			
			if (n.index==0){
				super.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, n.name, bkmk.previous.modified]));
			} else{
				super.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, n.sha1, bkmk.branch.modified]));
			}
		}
		
		public function discardUnsavedChanges():void
		{
			super.call(Vector.<String>([BashMethods.RESET_BRANCH]));
		}					

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.CHECKOUT_COMMIT :
					AppModel.proxy.bookmark.branch = AppModel.bookmark.detach;
				break;					
				case BashMethods.CHECKOUT_BRANCH :
					AppModel.proxy.bookmark.branch = AppModel.bookmark.previous;
				break;	
			}
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessFailure(e)");
		}
		
	}
	
}
