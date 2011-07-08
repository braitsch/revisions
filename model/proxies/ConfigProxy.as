package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessQueue;
	import system.BashMethods;
	import system.SystemRules;

	public class ConfigProxy extends NativeProcessQueue {

		private static var _userName			:String;		private static var _userEmail			:String;
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
		
		public function updatePackageManager():void
		{
			switch(_gitInstall){
				case SystemRules.MACPORTS :
					super.queue = [	Vector.<String>([BashMethods.MACPORTS]) ];			
				break;
				case SystemRules.HOMEBREW : 
					super.queue = [	Vector.<String>([BashMethods.HOMEBREW]) ];	
				break;
			}
		}
		
		private function getLoggedInUsersRealName():void
		{	
			super.queue = [	Vector.<String>([BashMethods.GET_USER_REAL_NAME]) ];
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
			trace(o.method, 'completed', o.result);
			switch(o.method){
				case BashMethods.INSTALL_GIT :
					onInstallComplete();
				break;
				case BashMethods.MACPORTS :
					onInstallComplete();
				break;					
				case BashMethods.HOMEBREW :
					onInstallComplete();
				break;	
				case BashMethods.GET_USER_REAL_NAME:
					onUserRealName(o.result);
				break;								
				case BashMethods.DETECT_GIT :
					if (o.result != ''){
						parseGitDetails(o.result);
					}	else{
						dispatchEvent(new AppEvent(AppEvent.GIT_NOT_INSTALLED));								
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
				dispatchEvent(new AppEvent(AppEvent.GIT_NEEDS_UPDATING));					
			}
		}

		private function onInstallComplete():void
		{
			dispatchEvent(new AppEvent(AppEvent.GIT_INSTALL_COMPLETE));
		}	
		
		private function checkUserNameAndEmail(n:String, e:String):void
		{
			_userEmail = e || 'yourname@yourdomain.com';
			if (e == ''){
				getLoggedInUsersRealName();
			}	else{
				_userName = n; 
				dispatchEvent(new AppEvent(AppEvent.GIT_SETTINGS));			
			}			
		}
		
		private function onUserRealName(n:String):void 
		{
			_userName = n;
			dispatchEvent(new AppEvent(AppEvent.GIT_SETTINGS));			
		}		
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var s:String = 'ConfigProxy.onProcessFailure(e)';
			trace(e.data.method);
			trace(e.data.result);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:e.data.method, r:e.data.result}));
		}

	}
	
}
