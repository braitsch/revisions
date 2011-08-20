package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class RemoteProxy extends NativeProcessProxy {

		private static var _timeout		:Timer = new Timer(5000, 1);
		
		protected function get timerIsRunning():Boolean { return _timeout.running; }
		
		protected function startTimer():void
		{
			_timeout.reset();		
			_timeout.start();
			_timeout.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchTimeOut);			
		}
		
		protected function stopTimer():void
		{
			_timeout.stop();
			_timeout.removeEventListener(TimerEvent.TIMER_COMPLETE, dispatchTimeOut);
		}
		
		private function dispatchTimeOut(e:TimerEvent):void
		{
			dispatchFailure(ErrorType.SERVER_FAILURE);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
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
