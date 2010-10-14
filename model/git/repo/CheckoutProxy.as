package model.git.repo {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.git.bash.BashMethods;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;
	import view.history.HistoryItem;

	public class CheckoutProxy extends NativeProcessProxy {

		private static var _status		:StatusProxy;
		private static var _target		:HistoryItem;

		public function CheckoutProxy(s:StatusProxy)
		{
			super.executable = 'Checkout.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			
			_status = s;
			_status.addEventListener(RepositoryEvent.BRANCH_MODIFIED, onModifiedReceived);	
		}

		public function set bookmark(b:Bookmark):void 
		{
			super.directory = b.local;
		}
		
		public function checkout(n:HistoryItem):void 
		{
			_target = n;
			trace('--------------------------------------');
			trace("RepositoryHistory.checkout >> Attempting to checkout >>", _target.sha1, 'on branch : '+_target.name);
		// always force refresh the status of the current branch before attempting a checkout	
			_status.getActiveBranchIsModified();	
		}	
		
		private function onModifiedReceived(e:RepositoryEvent):void 
		{
			var n:uint = e.data as uint;
			trace("CheckoutProxy.onModifiedReceived(e)", n);
			if (AppModel.branch.name == Bookmark.DETACH && n != 0){
				dispatchEvent(new RepositoryEvent(RepositoryEvent.COMMIT_MODIFIED));		
			}	else {
				allowCheckout(n);
			}					
		}

		private function allowCheckout(n:uint):void 
		{
			trace("CheckoutProxy.allowCheckout(m) >> previous = ", AppModel.branch.name);
			
			if (_target.index == 0){
			// temp //	
				var b:Branch = AppModel.bookmark.getBranchByName(_target.name);
				trace('attemping checkout of branch >> ', b.name, 'it was modified == ', b.modified!=0);
				
				var m:uint = AppModel.bookmark.getBranchByName(_target.name).modified;
				super.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, _target.name, m]));
			} else{
				super.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, _target.sha1, n]));
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
					AppModel.proxy.bookmark.branch = AppModel.bookmark.getBranchByName(_target.name);
				break;	
			}
			trace("CheckoutProxy.onProcessComplete(e)", e.data.method);
			trace('>> current branch = ', AppModel.proxy.bookmark.branch.name, '>> current tab = ', _target.name);
			
		// run a status request to update file view & history view with the active branch status //
			AppModel.proxy.status.getStatusOfBranch(AppModel.branch);
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}
	}
	
}
