package model.proxies.remote {

	import com.adobe.serialization.json.JSONDecoder;
	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.proxies.local.SSHProxy;
	import model.remote.RemoteAccount;
	import system.BashMethods;

	public class LoginProxy extends NativeProcessProxy {

		private static var _account		:RemoteAccount;

		public function LoginProxy()
		{
			super.executable = 'GitHubLogin.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function login(ra:RemoteAccount):void
		{
			_account = ra;
			super.call(Vector.<String>([BashMethods.LOGIN, _account.user, _account.pass]));
		}
		
		public function setPrimaryAccount(n:RemoteAccount, o:RemoteAccount = null):void
		{
			_account = n;
			if (o){
				super.call(Vector.<String>([BashMethods.REMOVE_KEY_FROM_REMOTE, o.user, o.pass]));
			}	else{
				super.call(Vector.<String>([BashMethods.ADD_KEY_TO_REMOTE, _account.user, _account.pass]));	
			}
		}					
		
		private function getRepositories():void
		{
			super.call(Vector.<String>([BashMethods.GET_REPOSITORIES, _account.user, _account.pass]));
		}		
		
		private function getRemoteKeyById():void
		{
			super.call(Vector.<String>([BashMethods.GET_REMOTE_KEY, _account.user, _account.pass, _account.sshKeyId]));	
		}
		
		private function repairRemoteKey():void
		{
			super.call(Vector.<String>([BashMethods.REPAIR_REMOTE_KEY, _account.user, _account.pass, _account.sshKeyId]));	
		}	
		
		private function authenticate():void
		{
			super.call(Vector.<String>([BashMethods.AUTHENTICATE]));	
		}										
		
	// repsonse handlers //	
	
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("GitHubLoginProxy.onProcessComplete(e)", e.data.method);
			var m:String = e.data.method; var r:String = e.data.result;
			switch(e.data.method){
				case BashMethods.LOGIN :
					onLoginResult(r);
				break;
				case BashMethods.GET_REPOSITORIES :
					if (!message(m, r)) onRepositories(r);
				break;				
				case BashMethods.GET_REMOTE_KEY :
					onRemoteKeyReceived(r);
				break;				
				case BashMethods.ADD_KEY_TO_REMOTE :
					onKeyAddedToRemote(r);
				break;
				case BashMethods.REPAIR_REMOTE_KEY :
					if (!message(m, r)) dispatchLoginComplete();
				break;				
				case BashMethods.REMOVE_KEY_FROM_REMOTE :
					if (!message(m, r)) dispatchLoginComplete();
				break;
				case BashMethods.AUTHENTICATE :
					dispatchEvent(new AppEvent(AppEvent.REMOTE_KEY_SET, _account));
				break;				
			}
		}

		private function message(m:String, r:String):Boolean
		{
			var o:Object = getResultObject(r);
			if (o.message == null){
				return false;
			}	else{
				o.method = m;
				dispatchDebug(o);		
				return true;
			}
		}
		
		private function onLoginResult(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == 'Bad credentials'){
				dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILED));			
			}	else if (o.message == 'No connection') {
				dispatchEvent(new AppEvent(AppEvent.OFFLINE));
			}	else if (o.message){
			// handle any other mysterious errors //
				o.method = BashMethods.LOGIN; dispatchDebug(o);
			}	else{
				_account.loginData = getResultObject(s);
				getRepositories();
			}
		}

		private function onRepositories(s:String):void
		{
			_account.repositories = getResultObject(s) as Array;
			if (_account.sshKeyId){
				getRemoteKeyById();
			}	else{
				dispatchLoginComplete();
			}
		}		
		
		private function onRemoteKeyReceived(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				validateKey(o.key);
			}	else {
				_account.sshKeyId = 0;
				dispatchLoginComplete();
			}
		}

		private function validateKey(rk:String):void
		{
	// truncate end so we can compare against github //
			var lk:String = SSHProxy.pbKey.substr(0, SSHProxy.pbKey.indexOf('==') + 2);
			if (lk != rk){
				repairRemoteKey();				
			}	else{
				dispatchLoginComplete();
			}
		}
		
		private function onKeyAddedToRemote(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				_account.sshKeyId = o.id;
				authenticate();
			}	else {
				trace("GitHubLoginProxy.onKeyAddedToRemote(s) -- attempt to add ssk-key failed");	
				dispatchLoginComplete();
			}
		}
		
	// helpers //			
		
		private function getResultObject(s:String):Object
		{
		// strip off any post headers we receive before parsing json //	
			if (s.indexOf('[') != -1) {
				return new JSONDecoder(s.substr(s.indexOf('[')), false).getValue();
			}	else if (s.indexOf('{') != -1){
				return new JSONDecoder(s.substr(s.indexOf('{')), false).getValue();
			}	else{
				return {result:s};
			}					
		}		
				
		private function dispatchLoginComplete():void
		{
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account));
		}

		private function dispatchDebug(o:Object):void
		{
			o.source = 'GithubKeyProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));			
		}					
		
	}
	
}
