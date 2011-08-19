package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.remote.Account;
	import system.BashMethods;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AccountProxy extends RemoteProxy {

		private static var _request		:String;
		private static var _baseURL		:String;
		private static var _account		:Account;
		private static var _timeout		:Timer = new Timer(5000, 1);

		public function AccountProxy()
		{
			super.executable = 'Account.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);			
		}
		
		protected function get account()				:Account 	{ return _account; 		}
		protected function set baseURL(baseURL:String)	:void 		{ _baseURL = baseURL; 	}	

	// login / logout //

		public function login(ra:Account):void
		{
			_account = ra;
			_request = BashMethods.LOGIN;
		}
		
		public function logout():void
		{
			_request = BashMethods.LOGOUT;
		// erase cached shell login vars ??	
			dispatchEvent(new AppEvent(AppEvent.LOGOUT_SUCCESS));
		}
		
	// add / remove repositories //			
		
		public function makeNewAccountRepo(name:String, desc:String, publik:Boolean):void
		{
			super.call(Vector.<String>([BashMethods.ADD_BKMK_TO_ACCOUNT, name, desc, publik]));
		}
		
	// add / remove collaborators //
	
	
	// private helper methods //			
		
		protected function getRepositories():void
		{
			_request = BashMethods.GET_REPOSITORIES;
		}												
		
		protected function makeRequest(url:String):void
		{
			startTimer();
			super.call(Vector.<String>(['makeRequest', _baseURL + url]));
		}	
	
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
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
		
		private function onProcessSuccess(result:String):void
		{
			switch(_request){
				case BashMethods.LOGIN :
					onLoginSuccess(result);
				break;
				case BashMethods.GET_REPOSITORIES :
					onRepositories(result);
				break;
				case BashMethods.ADD_BKMK_TO_ACCOUNT : 
					onRepositoryCreated(result);
				break;									
			}			
		}
		
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

	// callbacks //	
		
		protected function onLoginSuccess(s:String):void { }
		
		protected function onRepositories(s:String):void { }
		
		protected function onRepositoryCreated(s:String):void { }
		
	// timers & event dispatching //			
		
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
				
		private function dispatchTimeOut(e:TimerEvent):void
		{
			dispatchFailure(ErrorType.SERVER_FAILURE);
		}
		
		protected function dispatchLoginSuccess():void
		{
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account));
		}
		
		protected function dispatchFailure(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.FAILURE, m));
		}

	}
	
}
