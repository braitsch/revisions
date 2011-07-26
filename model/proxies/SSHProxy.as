package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;
	import com.adobe.serialization.json.JSONDecoder;

	public class SSHProxy extends NativeProcessProxy {
		
		private static var _ghKeyId		:String;
		private static var _publicKey	:String;
		
		public function SSHProxy()
		{
			super.executable = 'SSH.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function detectSSHKeys():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_SSH_KEYS]));
		}	
		
		private function generateKeys():void
		{
			trace("SSHProxy.generateKeys()");
			super.call(Vector.<String>([BashMethods.GENERATE_SSH_KEYS]));
		}
		
		private function detectGHKeyId():void
		{
			super.call(Vector.<String>([BashMethods.DETECT_GH_KEY_ID]));
		}					
		
		private function getGitHubKeys():void
		{
			super.call(Vector.<String>([BashMethods.GET_GH_KEYS]));
		}
		
		private function addKeysToGitHub():void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEYS_TO_GH]));
		}	
		
		private function repairGitHubKeys():void
		{
			super.call(Vector.<String>([BashMethods.REPAIR_GH_KEY]));
		}		
		
		private function authenticateGH(keyId:String):void
		{
			super.call(Vector.<String>([BashMethods.AUTHENTICATE_GH, keyId]));
		}				
		
	// response handlers //			
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("SSHProxy.onProcessComplete(e)", e.data.method, e.data.result);
			switch(e.data.method){
				case BashMethods.DETECT_SSH_KEYS :
					!e.data.result ? generateKeys() : onKeysDetected(e.data.result);
				break;		
				case BashMethods.GENERATE_SSH_KEYS:
					
				break;								
				case BashMethods.DETECT_GH_KEY_ID :
					onGHKeyIdFound(e.data.result);
				break;				
				default :
					onGitHubApiProcessComplete(e.data.method, e.data.result);		
				break;										
			}
		}
		
		private function onGitHubApiProcessComplete(m:String, r:String):void
		{
		//	trace("SSHProxy.onGitHubApiProcessComplete(m, r)", m, r);
			var o:Object = new JSONDecoder(r, false).getValue();	
			if (o.message){
				handleGitHubApiFailure(m, o.message);
			}	else{
				handleGitHubApiSuccess(m, o);						
			}
		}

		private function handleGitHubApiFailure(m:String, msg:String):void
		{
			switch(m){
				case BashMethods.REPAIR_GH_KEY :
					addKeysToGitHub();
				break;
				default :
			// handle any unknown github api timeouts or errors ..	
					dispatchDebug(m, msg);
				break;		
			}			
		}
		
		private function handleGitHubApiSuccess(m:String, o:Object):void 
		{
		//	trace("SSHProxy.handleGitHubApiSuccess(m, o)", m, o);
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
			}
		}
		
		private function onKeysDetected(s:String):void
		{
	// strip off username so we can compate against github //	
			_publicKey = s.substr(0, s.indexOf('==')+2);
			detectGHKeyId();
		}
		
		private function onGHKeyIdFound(s:String):void
		{
			_ghKeyId = s;
			getGitHubKeys();			
		}

		private function onGitHubKeyList(o:Object):void
		{
			var k:Object = compareKeys(o);
			if (k){
				authenticateGH(k.id);
			}	else{
				_ghKeyId ? repairGitHubKeys() : addKeysToGitHub();
			}			
		}

		private function compareKeys(o:Object):Object
		{
			for (var i:int = 0; i < o.length; i++) if (o[i].key == _publicKey) return o[i];
			return null;
		}

		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var m:String = e.data.method; var r:String = e.data.result;
			trace("SSHProxy.onProcessFailure(e)", m, r);
			if (m == BashMethods.GENERATE_SSH_KEYS && r.indexOf('Identity added') !=-1){
				detectSSHKeys();
			//	addKeysToGitHub();
			}	else if (m == BashMethods.AUTHENTICATE_GH && r.indexOf("You've successfully authenticated") != -1){
				AppModel.proxies.github.getRepositories();
			}	else if (m == BashMethods.AUTHENTICATE_GH && r.indexOf("Warning: Permanently added 'github.com") != -1){
				AppModel.proxies.github.getRepositories();
			}	else{
				dispatchDebug(m, r);
			}
		}
		
		private function dispatchDebug(m:String, r:String):void
		{
			var s:String = 'SSHProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, {s:s, m:m, r:r}));					
		}
		
	}
	
}
