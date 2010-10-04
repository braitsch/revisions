package model.git {
	import events.NativeProcessEvent;
	import events.RepositoryEvent;

	import model.air.NativeProcessProxy;

	import flash.events.EventDispatcher;

	public class BranchEditor extends EventDispatcher {
		
		private static var _proxy		:NativeProcessProxy;
		private static var _trim		:RegExp = /^\s+|\s+$/g;				
		
		public function BranchEditor()
		{
			_proxy = new NativeProcessProxy();	
			_proxy.executable = 'Branch.sh';
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);	
		}

		public function getBranches($dir:String):void
		{
			_proxy.directory = $dir;
			_proxy.call(Vector.<String>([BashMethods.GET_BRANCHES]));			
		}	
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("BranchEditor.onProcessComplete(e)", e.data.method, 'value = '+e.data.value);			 
			var m:String = String(e.data.method);
			switch(m){
				case BashMethods.GET_BRANCHES 	: parseBranchList(e.data.value);	break;
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("BranchEditor.onProcessFailure(e)");
		}			

		private function parseBranchList($s:String):void
		{
		//TODO this probably needs to be redone.	
		// split on line breaks //	
			var a:Array = $s.split(/(?:\r|\n)/);	
		// trim again any outside whitespace //
			for (var i : int = 0; i < a.length; i++) a[i] = a[i].replace(_trim, '');
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_LIST_RECEIVED));			
		}		
		
	}
	
}
