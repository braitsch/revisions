package model.air {
	import events.NativeProcessEvent;

	public class NativeProcessQueue extends NativeProcessProxy {

		private var _index			:uint;
		private var _queue			:Array;
		private var _results		:Array = [];
		private var _failed			:Boolean;
		private var _dieOnFailure	:Boolean = true;

		public function NativeProcessQueue($exec:String = '')
		{
			super($exec);
			addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);			addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);		}

		public function set queue($a:Array):void
		{
			_index = 0;
			_queue = $a;
			_results = [];
			_failed = false;
			super.call(_queue[_index]);
		}
		
		public function set dieOnFailure($die:Boolean):void
		{
			_dieOnFailure = $die;
		}		
		
	// private methods //	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			_failed = true;
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void
		{
			if (_failed && _dieOnFailure) return;
			_results.push(e.data.result);			
			callNextInQueue();
		}
		
		private function callNextInQueue():void
		{
			_index++;
			if (_index < _queue.length) {
				super.call(_queue[_index]);		
			}	else{
				dispatchEvent(new NativeProcessEvent(NativeProcessEvent.QUEUE_COMPLETE, _results));
			}					
		}
	
	}
	
}
