package model.proxies.remote.base {

	import system.BashMethods;
	import view.modals.system.Message;
	import view.modals.system.Debug;
	import events.AppEvent;
	import events.ErrEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class NetworkProxy extends NativeProcessProxy {

		private static var _timeout		:Timer = new Timer(20000, 1);
		
		protected function get timerIsRunning():Boolean { return _timeout.running; }
		
		override protected function call(v:Vector.<String>):void
		{
			var msg:String;
			switch(v[0]){
				case BashMethods.LOGIN :
					msg = 'Attemping Login';
				break;
				case BashMethods.ADD_REPOSITORY :
					msg = 'Uploading Bookmark';
				break;
				case BashMethods.GET_COLLABORATORS :
					msg = 'Fetching Collaborators';
				break;	
				case BashMethods.ADD_COLLABORATOR :
					msg = 'Adding Collaborator';
				break;	
				case BashMethods.KILL_COLLABORATOR :
					msg = 'Removing Collaborator';
				break;												
				
			}
			startTimer();
			super.call(v);
			if (msg) AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:msg}));
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
