package model.proxies {

	import system.StringUtils;
	import events.InstallEvent;
	import events.NativeProcessEvent;
	import model.air.NativeProcessQueue;
	import system.BashMethods;
	import system.SystemRules;

	public class ConfigProxy extends NativeProcessQueue {

		private static var _userName		:String;		private static var _userEmail		:String;
		private static var _gitVersion		:String;

		public function ConfigProxy()
		{
			super('Config.sh');
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onShellQueueComplete);
		}
		
	// this should only be called when first installing or updating git //	
		public function loadGitSettings():void
		{
			super.queue = [	Vector.<String>([BashMethods.GET_VERSION]),
							Vector.<String>([BashMethods.GET_USER_NAME]),
							Vector.<String>([BashMethods.GET_USER_EMAIL])];
		}			

	// public setters & getters //
	
		public function get userName():String { return _userName; }
		public function set userName($n:String):void
		{
			if ($n == _userName) return;
			super.queue = [	Vector.<String>([BashMethods.SET_USER_NAME, $n])	];
		}
		
		public function get userEmail():String { return _userEmail; }
		public function set userEmail($e:String):void
		{
			if ($e == _userEmail) return;
			super.queue = [	Vector.<String>([BashMethods.SET_USER_EMAIL, $e])	];
		}		
		
	// response handlers //			
		
		private function onShellQueueComplete(e:NativeProcessEvent):void 
		{
			if (e.data.length == 3){
				if (_userName == '' || _userEmail == ''){
					dispatchEvent(new InstallEvent(InstallEvent.NAME_AND_EMAIL));
				}	else{	
					dispatchEvent(new InstallEvent(InstallEvent.GIT_IS_READY));
				}
			}	else{
				dispatchEvent(new InstallEvent(InstallEvent.GIT_SETTINGS));
			}
		}

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			var r:String = StringUtils.trim(e.data.result);
			switch(e.data.method){
				case BashMethods.GET_VERSION : 
					_gitVersion = r.substring(12);
					if (_gitVersion < SystemRules.MIN_GIT_VERSION){
						super.die();
						dispatchEvent(new InstallEvent(InstallEvent.GIT_UNAVAILABLE, _gitVersion));
					}
				break;				
				case BashMethods.GET_USER_NAME : _userName = r; 	break;
				case BashMethods.SET_USER_NAME : _userName = r; 	break;
				case BashMethods.GET_USER_EMAIL : _userEmail = r; 	break;
				case BashMethods.SET_USER_EMAIL : _userEmail = r; 	break;
			}
		}			
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("ConfigProxy.onProcessFailure(e)", e.data.method, e.data.result);
			if (e.data.method == BashMethods.GET_VERSION){
				super.die();
				dispatchEvent(new InstallEvent(InstallEvent.GIT_UNAVAILABLE, '0'));				
			}
		}

	}
	
}
