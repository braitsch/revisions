package model.proxies {

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
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}
		
	// this should only be called when first installing or updating git //	
		public function getGitVersion():void
		{
			super.queue = [	Vector.<String>([BashMethods.GET_VERSION])];
		}

		public function setUserNameAndEmail(n:String, e:String):void
		{
			super.queue = [	Vector.<String>([BashMethods.SET_USER_NAME, n]),
							Vector.<String>([BashMethods.SET_USER_EMAIL, e])];				
		}
				
	// public setters & getters //
	
		public function get userName():String { return _userName; }
		public function get userEmail():String { return _userEmail; }	
		
	// response handlers //			
		
		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			if (e.data.length == 1){
				checkGitVersionNumber(e.data[0] as String);
			}	else if (e.data.length == 2){
				checkUserNameAndEmail(e.data[0], e.data[1]);
			}
		}
		
		private function checkGitVersionNumber(v:String):void
		{
			_gitVersion = v.substring(12);
			if (_gitVersion >= SystemRules.MIN_GIT_VERSION){
				getUserNameAndEmail();
			}	else{
				dispatchEvent(new InstallEvent(InstallEvent.GIT_UNAVAILABLE, _gitVersion));
			}			
		}
		
		private function checkUserNameAndEmail(n:String, e:String):void
		{
			if (n == '' || e == ''){
				dispatchEvent(new InstallEvent(InstallEvent.NAME_AND_EMAIL));
			}	else{
				_userName = n; _userEmail = e;
				dispatchEvent(new InstallEvent(InstallEvent.GIT_SETTINGS));
			}			
		}

		private function getUserNameAndEmail():void
		{
			super.queue = [	Vector.<String>([BashMethods.GET_USER_NAME]),
							Vector.<String>([BashMethods.GET_USER_EMAIL])];				
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
