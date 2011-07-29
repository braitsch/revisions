package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;
	import com.adobe.serialization.json.JSONDecoder;

	public class GitHubKeyProxy extends NativeProcessProxy {

		public function GitHubKeyProxy()
		{
			super.executable = 'GitHubKeys.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function validateKeys($keyName:String):void
		{
			AppModel.proxies.ssh.detectSSHKeys($keyName);
			AppModel.proxies.ssh.addEventListener(AppEvent.SSH_KEYS_READY, onSSHKeysReady);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.LOADER_TEXT, 'Checking SSH Keys'));			
		}

		private function onSSHKeysReady(e:AppEvent):void
		{
			super.call(Vector.<String>([BashMethods.GET_GH_KEYS]));
			AppModel.proxies.ssh.removeEventListener(AppEvent.SSH_KEYS_READY, onSSHKeysReady);
		}
		
		private function addKeysToGitHub():void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEYS_TO_GH, SSHProxy.pbKeyName]));
		}	
		
		private function repairGitHubKeys():void
		{
			super.call(Vector.<String>([BashMethods.REPAIR_GH_KEY, SSHProxy.pbKeyName, SSHProxy.pbKeyId]));
		}		
		
		private function authenticateGH(keyId:String):void
		{
			super.call(Vector.<String>([BashMethods.AUTHENTICATE_GH, SSHProxy.pbKeyName, keyId]));
		}
		
	// repsonse handlers //	
		
		private function handleProcessSuccess(e:NativeProcessEvent):void
		{
			var o:Object = getResultObject(e.data.result);
			if (o.message){
				onMessage(e.data.method, o);
			}	else{
				onSuccess(e.data.method, o);
			}	
		}

		private function handleProcessFailure(e:NativeProcessEvent):void
		{
			var m:String = e.data.method; var r:String = e.data.result;
			if (m == BashMethods.AUTHENTICATE_GH && r.indexOf("You've successfully authenticated") != -1){
				AppModel.proxies.githubApi.getRepositories();
			}	else{
				dispatchDebug(e.data);
			}		
		}
		
		private function getResultObject(s:String):Object
		{
			if (s.indexOf('[') == 0 || s.indexOf('{') == 0){
				return new JSONDecoder(s, false).getValue();
			}	else{
				return {result:s};
			}
		}		
		
		private function onSuccess(m:String, o:Object):void
		{
		//	trace("GitHubKeyProxy.onSuccess(m, o)", m);
			switch(m){	
				case BashMethods.GET_GH_KEYS :
					onGitHubKeyList(o);
				break;
				case BashMethods.ADD_KEYS_TO_GH :
					authenticateGH(o.id);					
				break;
				case BashMethods.REPAIR_GH_KEY :
					authenticateGH(o.id);
				break;																				
				case BashMethods.AUTHENTICATE_GH :
					AppModel.proxies.githubApi.getRepositories();
				break;
			}				
		}

		private function onMessage(m:String, o:Object):void
		{
			switch(m){
				case BashMethods.REPAIR_GH_KEY :
					addKeysToGitHub();
				break;
				default :
					o.method = m;
					dispatchDebug(o);
				break;		
			}			
		}	
		
	// response callbacks //			

		private function onGitHubKeyList(o:Object):void
		{
			var k:Object = compareKeys(o);
			if (k){
				authenticateGH(k.id);
			}	else{
				SSHProxy.pbKeyId ? repairGitHubKeys() : addKeysToGitHub();
			}			
		}

		private function compareKeys(o:Object):Object
		{
			var k:String = SSHProxy.pbKey;
	// strip off username so we can compare against github //			
			k = k.substr(0, k.indexOf('==') + 2);
			for (var i:int = 0; i < o.length; i++) if (o[i].key == k) return o[i];
			return null;
		}						
		
	// handle native process responses //			

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			failed==true ? handleProcessFailure(e) : handleProcessSuccess(e);
		}	
		
		private function dispatchDebug(o:Object):void
		{
			o.source = 'GithubKeyProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));			
		}					
		
	}
	
}
