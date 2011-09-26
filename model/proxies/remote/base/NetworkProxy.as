package model.proxies.remote.base {

	import events.AppEvent;
	import events.ErrEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import system.BashMethods;
	import view.windows.modals.system.Debug;
	import view.windows.modals.system.Message;

	public class NetworkProxy extends NativeProcessProxy {

		private static var _timeout		:Timer = new Timer(20000, 1);
		
		protected function get timerIsRunning():Boolean { return _timeout.running; }
		
		override protected function call(v:Vector.<String>):void
		{
			var m:String;
			switch(v[0]){
				case BashMethods.LOGIN :
					m = 'Attemping Login';
				break;
				case BashMethods.ADD_REPOSITORY :
					m = 'Uploading Bookmark';
				break;
				case BashMethods.GET_COLLABORATORS :
					m = 'Fetching Collaborators';
				break;	
				case BashMethods.ADD_COLLABORATOR :
					m = 'Adding Collaborator';
				break;	
				case BashMethods.KILL_COLLABORATOR :
					m = 'Removing Collaborator';
				break;
			}
			startTimer();
			super.call(v);
			if (m) AppModel.showLoader(m);
		}
		
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
			dispatchError(ErrEvent.SERVER_FAILURE);
		}
		
		protected function dispatchDebug(o:Object):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug(o)));
		}
				
		protected function dispatchError(m:String):void
		{
			AppModel.engine.dispatchEvent(new ErrEvent(m));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
		}
		
	}
	
}
