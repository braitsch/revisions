package model.proxies {

	import events.InstallEvent;
	import events.NativeProcessEvent;
	import model.air.NativeProcessQueue;
	import system.BashMethods;
	import system.SystemRules;

	public class ConfigProxy extends NativeProcessQueue {

		private static var _userName		:String;		private static var _userEmail		:String;
		private static var _gitVersion		:String;
		private static var _gitLocation		:String;
		private static var _gitInstalled	:Boolean = false;

		public function ConfigProxy()
		{
			super('Config.sh');
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		//	super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);			
		}

		public function get gitVersion():String { return _gitVersion; }
		public function get gitLocation():String { return _gitLocation; }
		public function get gitInstalled():Boolean { return _gitInstalled; }

		public function checkIfGitIsInstalled():void
		{
			super.queue = [	Vector.<String>([BashMethods.DETECT_GIT]) ];
		}

		public function installGit():void
		{	
			super.queue = [	Vector.<String>([BashMethods.INSTALL_GIT]) ];
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
			var a:Array = e.data as Array;
			if (a.length == 1){
				detectMethod(a);
			}	else if (e.data.length == 2){
				checkUserNameAndEmail(e.data[0].result, e.data[1].result);
			}
		}
		
		private function detectMethod(a:Array):void
		{
			if (a[0].method == BashMethods.DETECT_GIT){
				onGitDetails(a[0].result as String);
			}	else if (a[0].method == BashMethods.INSTALL_GIT){
				onInstallComplete();
			}			
		}

		private function onInstallComplete():void
		{
			dispatchEvent(new InstallEvent(InstallEvent.GIT_INSTALL_COMPLETE));			
		}
		
		private function onGitDetails(s:String):void
		{
			var a:Array = s.split(',');
			if (a.length == 2){
				_gitVersion = a[0].substring(12);
				_gitLocation = a[1];
				if (_gitVersion >= SystemRules.MIN_GIT_VERSION){
					_gitInstalled = true;
					getUserNameAndEmail();
				}	else{
					dispatchEvent(new InstallEvent(InstallEvent.GIT_NEEDS_UPDATING));
				}
			}	else{
				dispatchEvent(new InstallEvent(InstallEvent.GIT_NOT_INSTALLED));
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
		
//		private function printGitLocation():void
//		{
//			if (_gitLocation == SystemRules.MACPORTS) trace('git was installed via macports');
//			if (_gitLocation == SystemRules.HOMEBREW) trace('git was installed via homebrew');
//			if (_gitLocation == SystemRules.GIT_SCM_DMG) trace('git was installed via scm-pkg');
//		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("ConfigProxy.onProcessFailure(e)", e.data.method, e.data.result);
		}

	}
	
}
