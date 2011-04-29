package model.proxies {

	import events.InstallEvent;
	import events.NativeProcessEvent;
	import events.RepositoryEvent;
	import flash.events.EventDispatcher;
	import model.SystemRules;
	import model.air.NativeProcessQueue;
	import model.bash.BashMethods;

	public class ConfigProxy extends EventDispatcher {

		private static var _proxy			:NativeProcessQueue;
		private static var _userName		:String;		private static var _userEmail		:String;
		private static var _gitVersion		:String;

		public function ConfigProxy()
		{
			_proxy = new NativeProcessQueue('Config.sh');
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			_proxy.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onShellQueueComplete);
			loadUserSettings();
		}
		
		public function loadUserSettings():void
		{
	// expose this so it can be called again after installing / updating git //		
			_proxy.queue = [	Vector.<String>([BashMethods.GET_VERSION]),
								Vector.<String>([BashMethods.GET_USER_NAME]),
								Vector.<String>([BashMethods.GET_USER_EMAIL])	];						
		}			

	// public setters & getters //

		public function get userName():String
		{
			return _userName;
		}
		
		public function get userEmail():String
		{
			return _userEmail;
		}
		
		public function set userName($n:String):void
		{
			_proxy.queue = [	Vector.<String>([BashMethods.GET_USER_NAME, $n])	];
		}
		
		public function set userEmail($e:String):void
		{
			_proxy.queue = [	Vector.<String>([BashMethods.GET_USER_EMAIL, $e])	];
		}		
		
	// response handlers //			
		
		private function onShellQueueComplete(e:NativeProcessEvent):void 
		{
			dispatchEvent(new RepositoryEvent(RepositoryEvent.SET_USERNAME));
			dispatchEvent(new InstallEvent(InstallEvent.SET_GIT_VERSION, _gitVersion));			
		}

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case BashMethods.GET_VERSION : 
					_gitVersion = e.data.result.substring(12);
					if (_gitVersion < SystemRules.MIN_GIT_VERSION){
						_proxy.die();
						dispatchEvent(new InstallEvent(InstallEvent.GIT_UNAVAILABLE, _gitVersion));
					}
				break;				
				case BashMethods.GET_USER_NAME : 
					_userName = e.data.result;							break;
				case BashMethods.GET_USER_EMAIL : 
					_userEmail = e.data.result;
				break;
			}
		}			
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("ConfigProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}
					
	}
	
}
