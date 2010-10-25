package model.proxies {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.SystemRules;
	import model.air.NativeProcessQueue;
	import model.bash.BashMethods;

	import model.Bookmark;
	import model.Branch;

	public class StatusProxy extends NativeProcessQueue {

		public static const	T		:uint = 0; // tracked
		public static const	U		:uint = 1; // untracked		public static const	M		:uint = 2; // modified		public static const	I		:uint = 3; // ignored
				private static var _branch		:Branch;
		private static var _bookmark	:Bookmark;
		private static var _getHistory	:Boolean;

		public function StatusProxy()
		{
			super.executable = 'Status.sh';
			super.debug = false;
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_bookmark = b;
			super.directory = _bookmark.local;
		}		

	// public methods //	
		
		public function getStatusOfBranch($b:Branch):void
		{
			_branch = $b;
			trace("StatusProxy.getStatusOfBranch($b) >> requesting status of > ", _bookmark.label, _branch.name);
			super.queue = getStatusTransaction();						}
		
		public function getStatusAndHistory():void
		{
			_getHistory = true;
			getStatusOfBranch(AppModel.branch);
		}		
		
	// private handlers //
		
		private function onQueueComplete(e:NativeProcessEvent):void
		{
			trace("StatusProxy.onQueueComplete(e)");
			var a:Array = e.data as Array;
			switch(a.length){
				case 4 : parseFullBranchStatus(a);	break;
			}
			
		// also force refresh the history on commit //	
			if (_getHistory == true){
				_getHistory = false;
				AppModel.proxies.history.getHistoryOfBranch(_branch);
			}
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
			_branch.modified = a[M].length;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_STATUS, a));
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
			trace("StatusProxy.onProcessFailure(e)");
		}
		
		private function getStatusTransaction():Array
		{
			return [	Vector.<String>([BashMethods.GET_TRACKED_FILES]), 
						Vector.<String>([BashMethods.GET_UNTRACKED_FILES]),
						Vector.<String>([BashMethods.GET_MODIFIED_FILES]),							Vector.<String>([BashMethods.GET_IGNORED_FILES])];											
		}			

	}
	
}
