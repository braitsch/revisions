package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.remote.Account;
	import model.vo.Remote;
	import system.BashMethods;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AccountProxy extends RemoteProxy {

		protected static var _account		:Account;
		protected static var _timeout		:Timer = new Timer(5000, 1);

		public function AccountProxy()
		{
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}

	// login / logout //

		public function login(ra:Account):void
		{
			startTimer();
			_account = ra;
			super.call(Vector.<String>([BashMethods.LOGIN, _account.user, _account.pass]));
		}
		
		public function logout():void
		{
			super.call(Vector.<String>([BashMethods.LOGOUT]));
		}
		
	// add / remove repositories //			
		
		public function makeNewAccountRepo(name:String, desc:String, publik:Boolean):void
		{
			super.call(Vector.<String>([BashMethods.ADD_BKMK_TO_ACCOUNT, name, desc, publik]));
		}
		
	// add / remove collaborators //
	
	
	// private helper methods //			
		
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
					onLogoutResult();
				break;				
				case BashMethods.GET_REPOSITORIES :
					if (!message(m, r)) onRepositories(r);
				break;
				case BashMethods.ADD_BKMK_TO_ACCOUNT : 
					onRepositoryCreated(e.data.result);
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
				dispatchLoginFailure(ErrorType.LOGIN_FAILURE);
			}	else if (o.message == 'No connection') {
				dispatchLoginFailure(ErrorType.NO_CONNECTION);
			}	else if (o.message == 'Failed to connect to host') {
				dispatchLoginFailure(ErrorType.SERVER_FAILURE);				
			}	else if (o.message){
			// handle any other mysterious errors //
				o.method = BashMethods.LOGIN; dispatchDebug(o);
			}
		}
		
		private function onLogoutResult():void
		{
			dispatchEvent(new AppEvent(AppEvent.LOGOUT_SUCCESS));
		}

		private function onRepositories(s:String):void
		{
			if (_timeout.running != false) {
				_account.repositories = getResultObject(s) as Array;
				dispatchLoginSuccess();
			}
		}
		
		private function onRepositoryCreated(s:String):void
		{
			var o:Object = getResultObject(s);
			if (hasJSONErrors(o) == false){
				var r:Remote = new Remote(Account.GITHUB+'-'+o.name, o.ssh_url);
				AppModel.proxies.editor.addRemoteToLocalRepository(r);
				dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, o));
			}
		}
		
		private function hasJSONErrors(o:Object):Boolean
		{
			var f:Boolean;
			if (o.message == null) return false;
			if (o.errors[0].message == 'name is already taken'){
				f = true;
				dispatchLoginFailure('That repository name is already taken, please choose something else');
			} else if (o.errors[0].message == 'name can\'t be private. You are over your quota.'){
				f = true;
				dispatchLoginFailure('Whoops! Looks like you\'re all out of private repositories, consider making this one public or upgrade your account.');
			}
			return f;			
		}				
	
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
			dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILURE, ErrorType.SERVER_FAILURE));
		}
		
		protected function dispatchLoginSuccess():void
		{
			stopTimer();
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account));
		}
		
		private function dispatchLoginFailure(m:String):void
		{
			stopTimer();
			dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILURE, m));
		}
		
	}
	
}
