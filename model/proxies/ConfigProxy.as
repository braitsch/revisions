package model.proxies {

	import events.InstallEvent;
	import events.NativeProcessEvent;
	import events.UIEvent;
	import model.air.NativeProcessQueue;
	import system.BashMethods;
	import system.SystemRules;

	public class ConfigProxy extends NativeProcessQueue {

		private static var _userName			:String;		private static var _userEmail			:String;
		private static var _gitReady			:Boolean = false;
		private static var _gitInstall			:String;
		private static var _gitVersion			:String;
		private static var _loadedFromCache		:String;

		public function ConfigProxy()
		{
			super('Config.sh');
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}

		public function get userName():String { return _userName; }
		public function get userEmail():String { return _userEmail; }
		public function get gitReady():Boolean { return _gitReady; }
		public function get gitVersion():String { return _gitVersion; }
		public function get gitInstall():String { return _gitInstall; }
		public function get loadedFromCache():String { return _loadedFromCache; }

		public function detectGit():void
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
		
		private function getUserNameAndEmail():void
		{
			super.queue = [	Vector.<String>([BashMethods.GET_USER_NAME]),
							Vector.<String>([BashMethods.GET_USER_EMAIL])];				
		}		
		
	// response handlers //			
		
		private function onQueueComplete(e:NativeProcessEvent):void 
		{
			var a:Array = e.data as Array;
			if (a.length == 1){
				detectMethod(a[0]);
			}	else{
				checkUserNameAndEmail(a[0].result, a[1].result);				
			}
		}

		private function detectMethod(o:Object):void
		{
			switch(o.method){
				case BashMethods.INSTALL_GIT :
					onInstallComplete();
				break;
				case BashMethods.DETECT_GIT :
					if (o.result != 0){
						parseGitDetails(o.result);
					}	else{
						dispatchEvent(new InstallEvent(InstallEvent.GIT_NOT_INSTALLED));								
					}
				break;
			}
		}
		
		private function parseGitDetails(s:String):void
		{
			var a:Array = s.split(',');	
			_gitInstall = a[0];
			_gitVersion = a[1].substring(12);
			_loadedFromCache = a[2].substring(0, 5);
			if (_gitVersion >= SystemRules.MIN_GIT_VERSION){
				getUserNameAndEmail();
			}	else{
				dispatchEvent(new InstallEvent(InstallEvent.GIT_NEEDS_UPDATING));					
			}
		}

		private function onInstallComplete():void
		{
			dispatchEvent(new InstallEvent(InstallEvent.GIT_INSTALL_COMPLETE));
		}		
		
		private function checkUserNameAndEmail(n:String, e:String):void
		{
			_userName = n; _userEmail = e;
			if (n == '' || e == ''){
				dispatchEvent(new InstallEvent(InstallEvent.NAME_AND_EMAIL));
			}	else{
				_gitReady = true;
				dispatchEvent(new InstallEvent(InstallEvent.GIT_SETTINGS));
			}			
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var m:String = 'Sorry, it looks there was a problem! \n';
			m+='------------------------------- \n';			
			m+='ConfigProxy.onProcessFailure(e) \n';
			m+='method '+e.data.method+' failed \n';
			m+='error message = '+e.data.result;
			dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
		}

	}
	
}
