package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;

	public class BeanstalkProxy extends NativeProcessProxy {

		public function BeanstalkProxy()
		{
			super.executable = 'BeanStalkApi.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function login($name:String, $pass:String):void
		{
			super.call(Vector.<String>(['login', $name, $pass]));			
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("BeanstalkProxy.onProcessComplete(e)", e.data.method, e.data.result);
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'BeanstalkProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}
		
	}
	
}
