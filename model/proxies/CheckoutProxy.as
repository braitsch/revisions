package model.proxies {

	import events.NativeProcessEvent;
	import events.RepositoryEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.Branch;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	public class CheckoutProxy extends NativeProcessProxy {

		private static var _target		:*; // can be either a branch or commit object //
		private static var _status		:StatusProxy;
		private static var _bookmark	:Bookmark;

		public function CheckoutProxy(s:StatusProxy)
		{
			super.executable = 'Checkout.sh';
			super.debug = true;
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			
			_status = s;
			_status.addEventListener(RepositoryEvent.BRANCH_MODIFIED, onModifiedReceived);	
		}
		
		public function set bookmark(b:Bookmark):void 
		{
			super.directory = b.local;		}
		
		public function checkout(b:Bookmark, t:*):void
		{
			_target = t;
			_bookmark = b;
			trace("CheckoutProxy.checkout >> ", _bookmark.label, _target.name || _target.sha1);
			trace("CheckoutProxy.checkout >> getting modified status of ::", AppModel.bookmark.label, AppModel.branch.name);			
			_status.getActiveBranchIsModified();
		}
	
		public function discardUnsavedChanges():void
		{
			super.call(Vector.<String>([BashMethods.RESET_BRANCH]));
		}	
		
		private function onModifiedReceived(e:RepositoryEvent):void
		{
			var m:uint = e.data as uint;
			trace("CheckoutProxy.onModifiedReceived(e)", AppModel.branch.name, 'modified = ', m);
			if (m != 0){
				if (AppModel.branch.name == Bookmark.DETACH){
				// only prompt to save if changes were made on top of a previous commit //	
					dispatchEvent(new RepositoryEvent(RepositoryEvent.COMMIT_MODIFIED));
				}	else{
					pushStash();
				}
			}	else{	
				allowCheckout();
			}
		}
		
		private function pushStash():void
		{
	// stash the name of the current branch on the current bookmark //	
			trace("CheckoutProxy.onModifiedReceived(e) >> stashing ", AppModel.branch.name, 'length = '+AppModel.bookmark.stash.length);
			super.call(Vector.<String>([BashMethods.PUSH_STASH]));
		}
		
		private function allowCheckout():void
		{
			trace("CheckoutProxy.allowCheckout >> coming from =", AppModel.bookmark.label, AppModel.branch.name);
			var name:String = _target is Branch ? _target.name : _target.sha1;
			super.directory = _bookmark.local;
			trace("CheckoutProxy.allowCheckout >> going to = ", _bookmark.label, name);
			super.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, name]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessComplete(e)", e.data.method);
			switch(e.data.method){
				case BashMethods.PUSH_STASH :
					AppModel.bookmark.stash.unshift(AppModel.branch.name);
					allowCheckout();
				break;				
				case BashMethods.CHECKOUT_BRANCH :
					if (_target is Branch){
						checkIfBranchIsSavedInStash();
					}	else{
						setBranch(_bookmark.detach);
					}
				break;	
				case BashMethods.POP_STASH :
					setBranch(_bookmark.getBranchByName(_target.name));
				break;			}
		}
		
		private function setBranch(b:Branch):void
		{
			trace("CheckoutProxy.setBranch >> setting bookmark & branch to ::", _bookmark.label, b.name);
			_bookmark.branch = b;
		// -- once dispatched this updates everything in the application -- //				
			AppModel.engine.dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_SET, _bookmark));
		}
		
		private function checkIfBranchIsSavedInStash():void
		{
			var stashed:Boolean = false;
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
				setBranch(_bookmark.getBranchByName(_target.name));
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}
		
	}
	
}
