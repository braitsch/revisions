package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.remote.RemoteAccount;
	import system.BashMethods;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class UserProxy extends RemoteProxy {

		private static var _account		:RemoteAccount;
		private static var _timeout		:Timer = new Timer(5000, 1);

		public function UserProxy()
		{
			super.executable = 'GitHubLogin.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

		public function login(ra:RemoteAccount):void
		{
			startTimer();
			_account = ra;
			super.call(Vector.<String>([BashMethods.LOGIN, _account.user, _account.pass]));
		}
		
		public function logout():void
		{
			super.call(Vector.<String>([BashMethods.LOGOUT]));
		}		
		
		private function getRepositories():void
		{
			super.call(Vector.<String>([BashMethods.GET_REPOSITORIES]));
		}												
		
	// repsonse handlers //	
	
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method; var r:String = e.data.result;
			switch(e.data.method){
				case BashMethods.LOGIN :
					onLoginResult(r);
				break;
				case BashMethods.LOGOUT :
					dispatchEvent(new AppEvent(AppEvent.LOGOUT_SUCCESS));
				break;				
				case BashMethods.GET_REPOSITORIES :
					if (!message(m, r)) onRepositories(r);
				break;				
			}
		}

	// callbacks //	
		
		private function onLoginResult(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				_account.loginData = getResultObject(s);
				getRepositories();
			}	else if (o.message == 'Bad credentials'){
				dispatchEvent(new AppEvent(AppEvent.FAILURE, ErrorType.LOGIN_FAILURE));
			}	else if (o.message == 'No connection') {
				dispatchEvent(new AppEvent(AppEvent.FAILURE, ErrorType.NO_CONNECTION));
			}	else if (o.message == 'Failed to connect to host') {
				dispatchEvent(new AppEvent(AppEvent.FAILURE, ErrorType.SERVER_FAILURE));				
			}	else if (o.message){
			// handle any other mysterious errors //
				o.method = BashMethods.LOGIN; dispatchDebug(o);
			}
		}

		private function onRepositories(s:String):void
		{
			if (_timeout.running != false) {
				stopTimer();
				_account.repositories = getResultObject(s) as Array;
				dispatchLoginComplete();
			}
		}
	
	// helpers //			
		
		private function startTimer():void
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
				
		private function dispatchLoginComplete():void
		{
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account));
		}

		private function dispatchTimeOut(e:TimerEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.FAILURE, ErrorType.SERVER_FAILURE));
		}
		
	}
	
}
