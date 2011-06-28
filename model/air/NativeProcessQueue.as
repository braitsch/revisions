package model.air {
	import flash.events.EventDispatcher;
	import events.NativeProcessEvent;

	public class NativeProcessQueue extends EventDispatcher {

		private var _index			:uint;
		private var _queue			:Array; // an array of vectors //
		private var _results		:Array = [];
		private var _proxy			:NativeProcessProxy;

		public function NativeProcessQueue($exec:String = '')
		{
			_proxy = new NativeProcessProxy($exec);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}

		public function set queue($a:Array):void
		{
			_index = 0;
			_queue = $a;
			_results = [];
			_proxy.call(_queue[_index]);
		}
		
		public function set directory($d:String):void
		{
			_proxy.directory = $d;
		}
		
		public function die():void
		{
			_queue = [];
		}
		
	// private methods //	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			_queue = [];
			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_FAILURE, e.data));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void
		{
			_index++;
			_results.push(e.data);	
			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_COMPLETE, e.data));
			if (_index < _queue.length) {
				_proxy.call(_queue[_index]);
			}	else if (_index == _queue.length){
				dispatchEvent(new NativeProcessEvent(NativeProcessEvent.QUEUE_COMPLETE, _results));
			}		
		}
		
	}
	
}
