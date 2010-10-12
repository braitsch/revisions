package model.git {
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
			_proxy.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onStatusComplete);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
		public function set bookmark(b:Bookmark):void 
		{
			_bookmark = b;
			_proxy.directory = _bookmark.local;
		}		
		
		public function getStatusOfBranch($b:Branch = null):void
		{
			_branch = $b || _bookmark.branch;
			_proxy.queue = getTransaction();						}
		
		private function onStatusComplete(e:NativeProcessEvent):void 
		{
			trace("RepositoryStatus.StatusComplete(e)", _bookmark.label, _branch.name);
			var i:int = 0, j:int = 0; 
			var m:Boolean = false;
			var r:Array = e.data as Array;
		// first split the four returned strings into four arrays //	
			for (i = 0; i < 4; i++) {				if (r[i]=='') {
					r[i] = [];
				}	else{
					r[i] = r[i].split(/[\n\r\t]/g);
		// remove any forbidden and / or hidden files //
					purgeForbiddenFiles(r[i]);
				}
			}
			
		// remove modified files from the all tracked files array //
			i = j = 0;
			while(i < r[T].length){
				m = false;
				for (j = 0; j < r[M].length; j++) {
					if (r[T][i]==r[M][j]) {
						r[T].splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}
			
		// remove intentionally ignored files from the untracked files array //			i = j = 0;
			while(i < r[U].length){
				m = false;
				for (j = 0; j < r[I].length; j++) {
					if (r[U][i]==r[I][j]){
						 r[U].splice(i, 1); m=true; break;
					}
				}
				if (!m) i++;
			}						
			
		//	for (i = 0; i < 4; i++) trace('result set '+i+' = ', r[i]);
			_branch.status = r;
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
		
		private function getTransaction():Array
		{
			return [	Vector.<String>([BashMethods.GET_MODIFIED_FILES, _branch.name]),
						Vector.<String>([BashMethods.GET_TRACKED_FILES, _branch.name]), 
						Vector.<String>([BashMethods.GET_UNTRACKED_FILES, _branch.name]),																		Vector.<String>([BashMethods.GET_IGNORED_FILES, _branch.name])];											
		}			
		
	}
	
}
