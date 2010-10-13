package model.git.repo {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.git.bash.BashMethods;

	import view.bookmarks.Bookmark;

	public class BranchProxy extends NativeProcessProxy{

		private static var _index		:uint = 0;
		private static var _bookmarks 	:Vector.<Bookmark>;

		public function BranchProxy() 
		{	
			super.executable = 'Branch.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}	
		
		public function set repositories(a:Array):void
		{
			trace("BranchProxy.onRepositories(e) > creating bookmarks from database data");
			var v:Vector.<Bookmark> = new Vector.<Bookmark>();
			
			for (var i : int = 0; i < a.length; i++) {
				var b:Bookmark = new Bookmark(a[i].name, a[i].location, 'remote', a[i].active==1);
				if (b.file.exists) {
					v.push(b);
				}	else{
			//		dispatchEvent(new UICommand(UICommand.REPAIR_BOOKMARK, b));
					dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_PATH_ERROR));
					return;
				}
			}
			trace("BranchProxy.onRepositories(e) > bookmark objects created");
			_bookmarks = v;
			getBranchesOfBookmark(_bookmarks[_index]);			
		}

		public function addBranch($name:String):void
		{
			trace("BranchProxy.addBranch($new)", $name, AppModel.bookmark.previous.name);
			super.call(Vector.<String>([BashMethods.ADD_BRANCH, $name, AppModel.bookmark.previous.name]));
		}
		
	// private methods //	
		
		private function getBranchesOfBookmark(b:Bookmark):void
		{
			trace("BranchProxy.getBranchesOfBookmark(b) > ", b.label);
			super.directory = b.local;
			super.call(Vector.<String>([BashMethods.GET_BRANCHES]));			
		}
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.GET_BRANCHES:
					var a:Array = e.data.result.split(/[\n\r\t]/g);
					var k:Boolean = _bookmarks[_index].attachBranches(a);
					
					if (k == true){
						getBranchesOfNextBookmark();
					}	else{
						dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_DETACHED, _bookmarks[_index]));
					}
					
				break;		
			}
		}

		private function getBranchesOfNextBookmark():void 
		{
			if (++_index < _bookmarks.length){
				getBranchesOfBookmark(_bookmarks[_index]);
			}	else{
				dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARKS_READY, _bookmarks));
			}			
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("BranchEditor.onProcessFailure(e)");
		}		
		
	}
	
}
