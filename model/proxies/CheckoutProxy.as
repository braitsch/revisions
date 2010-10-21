package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	import model.Branch;
	import model.Bookmark;
	import view.history.HistoryListItem;

	public class CheckoutProxy extends NativeProcessProxy {

		private static var _status		:StatusProxy;
		private static var _target		:HistoryListItem;
		private static var _bookmark	:Bookmark;

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
			_bookmark = b;
			super.directory = b.local;
		}
		
		public function checkout(n:HistoryListItem):void 
		{
			_target = n;
			trace('--------------------------------------');
			trace("CheckoutProxy.checkout >> Attempting to checkout >>", _target.sha1, 'on branch : '+_target.name);
		// always force refresh the status of the current branch before attempting a checkout	
			_status.getActiveBranchIsModified();	
		}	
		
		private function onModifiedReceived(e:RepositoryEvent):void 
		{
			var m:uint = e.data as uint;
			trace("CheckoutProxy.onModifiedReceived(e)", AppModel.branch.name, 'modified = ', m);
			if (AppModel.branch.name == Bookmark.DETACH && m != 0){
				dispatchEvent(new RepositoryEvent(RepositoryEvent.COMMIT_MODIFIED));		
			}	else {
				allowCheckout(m);
			}					
		}

		private function allowCheckout(m:uint):void 
		{
			trace("CheckoutProxy.allowCheckout(m) >> precheck-out branch = ", AppModel.branch.name);
			
			if (m > 0) _bookmark.stash.unshift(AppModel.branch.name);
			
			if (_target.index == 0){
			// temp //	
				var b:Branch = AppModel.bookmark.getBranchByName(_target.name);
				trace('attemping checkout of branch >> ', b.name, 'it was modified ==', b.modified!=0);
	
				super.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, _target.name, m]));
			} else{
				super.call(Vector.<String>([BashMethods.CHECKOUT_COMMIT, _target.sha1, m]));
			}				
		}

		public function discardUnsavedChanges():void
		{
			super.call(Vector.<String>([BashMethods.RESET_BRANCH]));
		}	

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.CHECKOUT_COMMIT :
					setBranch(AppModel.bookmark.detach);
				break;					
				case BashMethods.CHECKOUT_BRANCH :
					checkIfBranchIsSavedInStash();
				break;	
				case BashMethods.POP_STASH :
					setBranch(AppModel.bookmark.getBranchByName(_target.name));
				break;			}
		}
		
		private function setBranch(b:Branch):void
		{
			AppModel.bookmark.branch = b;
		// run a status request to update file view & history view with the active branch status //
			AppModel.proxies.status.getStatusOfBranch(AppModel.branch);
			trace('>> current branch = ', AppModel.branch.name, '>> current tab = ', _target.name);
		}
		
		private function checkIfBranchIsSavedInStash():void
		{
			var stashed:Boolean;
			for (var i:int = 0; i < _bookmark.stash.length; i++) {
				if (_bookmark.stash[i] == _target.name) {
					_bookmark.stash.splice(i, 0);
					stashed = true; break;
				}
			}
			if (stashed){
				trace("CheckoutProxy.checkIfBranchIsSavedInStash() >> true");				super.call(Vector.<String>([BashMethods.POP_STASH, i]));
			}	else{
				trace("CheckoutProxy.checkIfBranchIsSavedInStash() >> false");
				setBranch(AppModel.bookmark.getBranchByName(_target.name));
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}
		
	}
	
}
