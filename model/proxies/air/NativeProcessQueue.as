package model.proxies.air {

	import events.NativeProcessEvent;

	public class NativeProcessQueue extends NativeProcessProxy {

		private var _index			:uint;
		private var _queue			:Array; // an array of vectors //
		private var _results		:Array = [];

		public function NativeProcessQueue()
		{
			addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}

		public function set queue($a:Array):void
		{
			_index = 0;
			_queue = $a;
			_results = [];
			call(_queue[_index]);
		}
		
	// private methods //	
		
		private function onProcessComplete(e:NativeProcessEvent):void
		{
		//	trace("NativeProcessQueue.onProcessComplete(e)", e.data.method, e.data.result);
			_index++; _results.push(e.data);	
			if (_index < _queue.length) {
				call(_queue[_index]);
			}	else if (_index == _queue.length){
				dispatchEvent(new NativeProcessEvent(NativeProcessEvent.QUEUE_COMPLETE, _results));
			}		
		}
		
	}
	
}
