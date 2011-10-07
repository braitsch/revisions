package model.proxies.remote {

	import events.AppEvent;
	import events.ErrEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessProxy;
	import system.BashMethods;
	import view.windows.modals.system.Debug;
	import view.windows.modals.system.Message;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class RemoteProxy extends NativeProcessProxy {

		private static var _timeout:Timer = new Timer(0, 1);

		public function RemoteProxy()
		{
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		override protected function call(v:Vector.<String>):void
		{
			var m:String;
			var n:uint = 8000;
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
				case BashMethods.PUSH_BRANCH:
					n = 0;
				break;
				case BashMethods.CLONE :
					n = 0;
					m = 'Cloning Remote Repository';
				break;	
			}
			super.call(v);
			if (n) startTimer(n);
			if (m) AppModel.showLoader(m);
		}
		
		protected function onProcessComplete(e:NativeProcessEvent):void 
		{ 
			stopTimer();
		}		
		
		private function startTimer(n:uint):void
		{
			_timeout.delay = n;
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
