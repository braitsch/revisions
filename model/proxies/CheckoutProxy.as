package model.proxies {

	import events.BookmarkEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.Bookmark;
	import model.Branch;
	import model.Commit;
	import model.air.NativeProcessProxy;
	import model.bash.BashMethods;

	public class CheckoutProxy extends NativeProcessProxy {

		private static var _target		:*; // can be either a branch or commit object //
		private static var _bookmark	:Bookmark;

		public function CheckoutProxy()
		{
			super.executable = 'Checkout.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function download(sha1:String, saveAs:String, file:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.DOWNLOAD_VERSION, sha1, saveAs, file]));
		}
		
	// this should only be called if we are changing branches on a bookmark //	
		public function checkout(x:*):void
		{
			_target = x;			super.call(Vector.<String>([BashMethods.GET_NUM_IN_INDEX, _bookmark.branch]));
		}
		
		public function discardUnsavedChanges():void
		{
			super.call(Vector.<String>([BashMethods.RESET_BRANCH]));			
		}
		
		public function addBranch($name:String):void
		{
			_bookmark.addBranch(new Branch($name));
			super.call(Vector.<String>([BashMethods.ADD_BRANCH, $name]));
		}		
		
		private function onBranchModifiedStatus(n:uint):void
		{
			if (n == 0){
				allowCheckout();
			} else {
				if (_bookmark.branch.name == Bookmark.DETACH){
					dispatchEvent(new BookmarkEvent(BookmarkEvent.COMMIT_MODIFIED));					
				}	else{
					stashUnsavedChanges();
				}
			}
		}

		private function stashUnsavedChanges():void
		{
			_bookmark.stash.unshift(_bookmark.branch.name);
			super.call(Vector.<String>([BashMethods.PUSH_STASH]));			
		}
		
		private function allowCheckout():void
		{
			super.call(Vector.<String>([BashMethods.CHECKOUT_BRANCH, _target is Branch ? _target.name : _target.sha1]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method) {
				case BashMethods.GET_NUM_IN_INDEX :
					onBranchModifiedStatus(e.data.result);
				break;
				case BashMethods.PUSH_STASH :
					allowCheckout();
				break;				
				case BashMethods.CHECKOUT_BRANCH :
					if (_target is Commit){
						setBranch(_bookmark.detach);
					}	else{
						checkIfBranchIsSavedInStash();
					}
				break;	
				case BashMethods.POP_STASH :
					setBranch(_bookmark.getBranchByName(_target.name));
					break;
				case BashMethods.RESET_BRANCH :
					allowCheckout();
				break;		
				case BashMethods.ADD_BRANCH:
					_bookmark.dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCH_ADDED));
				break;									}
		}
		
		private function setBranch(b:Branch):void
		{
			trace("CheckoutProxy.setBranch >> setting bookmark & branch to ::", _bookmark.label, b.name);
			_bookmark.branch = b;
		// -- once dispatched this updates everything in the application -- //				
			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, _bookmark));
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
				super.call(Vector.<String>([BashMethods.POP_STASH, i]));
			}	else{
				setBranch(_bookmark.getBranchByName(_target.name));
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("CheckoutProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}
		
	}
	
}
