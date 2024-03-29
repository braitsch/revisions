package model.proxies.local {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.proxies.air.NativeProcessQueue;
	import system.BashMethods;
	import view.windows.modals.system.Debug;

	public class ConfigProxy extends NativeProcessQueue {

		private static var _userName			:String;		private static var _userEmail			:String;
		private static var _gitVersion			:String;

		public function ConfigProxy()
		{
			super.executable = 'Config.sh';
			super.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onQueueComplete);
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
		}

		public function get userName():String { return _userName; }
		public function get userEmail():String { return _userEmail; }
		public function get gitVersion():String { return _gitVersion; }

		public function detectGit():void
		{
			super.queue = [	Vector.<String>([BashMethods.DETECT_GIT]) ];
		}
		
		private function installGit():void
		{
			super.queue = [	Vector.<String>([BashMethods.INSTALL_GIT]) ];
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
			trace("ConfigProxy.detectMethod(o)", o.method, o.result);
			switch(o.method){	
				case BashMethods.DETECT_GIT :
					onGitDetected(o.result);
				break;
				case BashMethods.INSTALL_GIT :
					onGitInstalled(o.result);
				break;				
				case BashMethods.GET_USER_REAL_NAME :
					onUserRealName(o.result);
				break;								
			}
		}

		private function onGitDetected(s:String):void
		{
			s == '0' ? installGit() : onGitInstalled(s);
		}

		private function onGitInstalled(s:String):void
		{
			_gitVersion = s.substring(12);
			getUserNameAndEmail();
		}		

		private function checkUserNameAndEmail(n:String, e:String):void
		{
			_userEmail = e || 'yourname@yourdomain.com';
			if (!n){
				getLoggedInUsersRealName();
			}	else{
				_userName = n;
				AppModel.dispatch(AppEvent.GIT_SETTINGS);
			}			
		}
		
		private function onUserRealName(n:String):void 
		{
			_userName = n;
			setUserNameAndEmail(_userName , _userEmail);
		}	
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			e.data.source = 'ConfigProxy.onProcessFailure(e)';
			AppModel.alert(new Debug(e.data));
		}

	}
	
}
