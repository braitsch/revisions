package model.git {
	import model.AppModel;
	import events.RepositoryEvent;
	import events.NativeProcessEvent;

	import model.SystemRules;
	import model.air.NativeProcessQueue;

	import view.bookmarks.Bookmark;
	import view.bookmarks.Branch;

	import flash.events.EventDispatcher;

	public class RepositoryStatus extends EventDispatcher {

		public static const	M		:uint = 0; // modified
		public static const	T		:uint = 1; // tracked		public static const	U		:uint = 2; // untracked		public static const	I		:uint = 3; // ignored
				private static var _proxy		:NativeProcessQueue;
		private static var _branch		:Branch;
		private static var _bookmark	:Bookmark;

		public function RepositoryStatus()
		{
			_proxy = new NativeProcessQueue('Status.sh');
			_proxy.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
	// public methods //	
		
		public function set bookmark(b:Bookmark):void 
		{
			_bookmark = b;
			_proxy.directory = _bookmark.local;
		}		
		
		public function getStatusOfBranch($b:Branch):void
		{
			_branch = $b;
			_proxy.queue = getStatusTransaction();						}
		
		public function getActiveBranchIsModified():void 
		{
		// this is only called prior to a checkout attempt > in history viewer //	
			_branch = AppModel.repos.bookmark.branch;
			_proxy.queue = [	Vector.<String>([BashMethods.GET_MODIFIED_FILES])	];				
		}
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			var a:Array = e.data as Array;
			trace("RepositoryStatus.onQueueComplete(e)", _bookmark.label, _branch.name);
			switch(a.length){
				case 1 : parseModifiedFiles(a);		break;				case 4 : parseFullBranchStatus(a);	break;
			}
			_branch.modified = a[M].length;
			trace('modifed set on ', _bookmark.label, _branch.name, 'to:', _branch.modified);
		}

		private function parseModifiedFiles(a:Array):void 
		{
			splitAndPurge(a);	
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_MODIFIED, a[M]!=0));				
		}

		private function parseFullBranchStatus(a:Array):void 
		{
			var i:int = 0, j:int = 0; 
			var m:Boolean = false;
			
			splitAndPurge(a);
			
		// remove modified files from the all tracked files array //
			i = j = 0;
			while(i < a[T].length){
				m = false;
				for (j = 0; j < a[M].length; j++) {
					if (a[T][i] == a[M][j]) {
						a[T].splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}
			
		// remove intentionally ignored files from the untracked files array //			i = j = 0;
			while(i < a[U].length){
				m = false;
				for (j = 0; j < a[I].length; j++) {
					if (a[U][i] == a[I][j]){
						 a[U].splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}						
			
		//	for (i = 0; i < 4; i++) trace('result set '+i+' = ', r[i]);
			_branch.status = a;
		}
		
		private function splitAndPurge(a:Array):void
		{
		// first split the four returned strings into four arrays //	
			for (var i:int = 0; i < a.length; i++) {
				if (a[i]=='') {
					a[i] = [];
				}	else{
					a[i] = a[i].split(/[\n\r\t]/g);
		// remove any forbidden and / or hidden files //
					purgeForbiddenFiles(a[i]);
				}
			}			
		}

		private function purgeForbiddenFiles(r:Array):void 
		{
			var i:int = 0;
			var m:Boolean = false;
			while(i < r.length){
				m = false;
				for (var k:int = 0; k < SystemRules.FORBIDDEN_FILES.length; k++) {
					if (r[i].indexOf(SystemRules.FORBIDDEN_FILES[k])!=-1) {
						r.splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}	
			if (SystemRules.TRACK_HIDDEN_FILES) return;
			i = 0;
			while(i < r.length){	
				var n:int = r[i].lastIndexOf('/') + 1;
				r[i].indexOf('.')==n ? r.splice(i, 1) : i++;
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("RepositoryStatus.onProcessFailure(e)");
		}
		
		private function getStatusTransaction():Array
		{
			return [	Vector.<String>([BashMethods.GET_MODIFIED_FILES]),
						Vector.<String>([BashMethods.GET_TRACKED_FILES]), 
						Vector.<String>([BashMethods.GET_UNTRACKED_FILES]),																		Vector.<String>([BashMethods.GET_IGNORED_FILES])];											
		}			

	}
	
}
