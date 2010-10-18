package model.proxies {
	import events.NativeProcessEvent;

	import model.air.NativeProcessProxy;

	public class MergeProxy extends NativeProcessProxy {

		public function MergeProxy()
		{
			super.executable = 'Merge.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function merge():void
		{
			
		}

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("MergeProxy.onProcessComplete(e)", e.data.method, e.data.result);
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("MergeProxy.onProcessFailure(e)", e.data.method);
		}
		
	}
	
}
