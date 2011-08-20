package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import com.adobe.serialization.json.JSONDecoder;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class RemoteProxy extends NativeProcessProxy {
		
		private static var _request		:String;		
		private static var _timeout		:Timer = new Timer(5000, 1);

		protected function get request()				:String 	{ return _request; 		}
		protected function set request(request:String)	:void 		{ _request = request; 	}		

		public function RemoteProxy()
		{
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);			
		}

		protected function message(m:String, r:String):Boolean
		{
			var o:Object = getResultObject(r);
			if (o.message == null){
				return false;
			}	else{
				o.method = m;
				dispatchDebug(o);		
				return true;
			}
		}
		
		protected function getResultObject(s:String):Object
		{
		// strip off any post headers we receive before parsing json //	
			var k:String = s.charAt(s.length - 1);
			if (k == '}'){
				return new JSONDecoder(s.substr(s.indexOf('{')), false).getValue();
			}	else if (k == ']'){
				return new JSONDecoder(s.substr(s.indexOf('[')), false).getValue();
			}	else{
				return {result:s};
			}					
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void
		{
			trace("RemoteProxy.onProcessComplete(e)", _request, 'response='+e.data.result);
			if (_timeout.running == true){
				stopTimer();
				var s:String = e.data.result; 
				var r:String = s.substr(s.indexOf(',') + 1);
				var x:uint = uint(s.substr(0, s.indexOf(',')));
				if (x == 0){
					onProcessSuccess(r);
				}	else{
					onProcessFailure(x);		
				}
			}			
		}
		
		protected function onProcessSuccess(r:String):void { }
		
		private function onProcessFailure(x:uint):void
		{
			switch(x){
				case 6 :
					dispatchFailure(ErrorType.NO_CONNECTION);
				break;
				case 7 :
					dispatchFailure(ErrorType.SERVER_FAILURE);
				break;
				default :
			// handle any other mysterious errors we get back from curl //
				dispatchDebug({method:_request, message:'Request failed with exit code : '+x});
			}
		}				
		
		protected function startTimer():void
		{
			_timeout.reset();		
			_timeout.start();
			_timeout.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchTimeOut);			
		}
		
		private function stopTimer():void
		{
			_timeout.stop();
			_timeout.removeEventListener(TimerEvent.TIMER_COMPLETE, dispatchTimeOut);
		}
		
		private function dispatchTimeOut(e:TimerEvent):void
		{
			dispatchFailure(ErrorType.SERVER_FAILURE);
		}		
		
		protected function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}			
		
		protected function dispatchFailure(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.FAILURE, m));
		}			
		
		protected function dispatchDebug(o:Object):void
		{
			o.source = 'RemoteProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));
		}

	}
	
}
