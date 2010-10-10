package model.git {
	import events.NativeProcessEvent;

	import model.AppModel;
	import model.air.NativeProcessProxy;

	import view.bookmarks.Bookmark;

	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class RepositoryEditor extends EventDispatcher {

		private static var _proxy		:NativeProcessProxy;

		public function RepositoryEditor()
		{
			_proxy = new NativeProcessProxy();	
			_proxy.executable = 'Editor.sh';
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function set bookmark(b:Bookmark):void 
		{
			_proxy.directory = b.local;
		}

		public function commit($msg:String):void
		{
			_proxy.call(Vector.<String>([BashMethods.COMMIT, $msg]));					
		}
		
		public function trackFile($file:File):void
		{
			_proxy.call(Vector.<String>([BashMethods.TRACK_FILE, $file.nativePath]));
		}
		
		public function unTrackFile($file:File):void
		{
			_proxy.call(Vector.<String>([BashMethods.UNTRACK_FILE, $file.nativePath]));
		}
		
		public function ignoreFile($file:File):void
		{
//			_proxy.call(Vector.<String>([BashMethods.COMMIT, $msg]));					
		}
		
		public function unIgnoreFile($file:File):void
		{
//			_proxy.call(Vector.<String>([BashMethods.COMMIT, $msg]));					
		}
		
	// add / remove bookmarks	
		
		public function initRepository($local:String):void 
		{
			_proxy.call(Vector.<String>([BashMethods.INIT_REPOSITORY, $local]));				
		}	
		
		public function deleteRepository($o:Object):void 
		{
			_proxy.call(Vector.<String>([BashMethods.DELETE_REPOSITORY, $o.local, $o.killGit, $o.trash]));				
		}						
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("RepositoryEditor.onProcessComplete(e)", 'method = '+e.data.method, 'result = '+e.data.result);
			switch(e.data.method){
				case BashMethods.COMMIT : 
					AppModel.history.getHistoryOfBranch();				break;				case BashMethods.TRACK_FILE : 					AppModel.status.getStatusOfBranch();				break;
				case BashMethods.UNTRACK_FILE : 
					AppModel.status.getStatusOfBranch();
				break;
			}
		}	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("RepositoryEditor.onProcessFailure(e)");
		}				
		
	}
	
}
