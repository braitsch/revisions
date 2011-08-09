package model.proxies {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import model.remote.RemoteAccount;
	import system.BashMethods;
	import com.adobe.serialization.json.JSONDecoder;

	public class GitHubKeyProxy extends NativeProcessProxy {

		private static var _ghKeyId		:String;
		private static var _primary		:RemoteAccount;

		public function GitHubKeyProxy()
		{
			super.executable = 'GitHubKeys.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function checkKeysOnPrimaryAccount(ra:RemoteAccount):void
		{
			_primary = ra; getCachedKeyId();
		}
		
		public function changePrimaryAccount(o:RemoteAccount, n:RemoteAccount):void
		{
			_primary = n; removeKeyFromRemote(o);
		}
		
	// private methods //	
		
		private function getCachedKeyId():void
		{
			super.call(Vector.<String>([BashMethods.GET_CACHED_KEY_ID]));	
		}
		
		private function getRemoteKeys(ra:RemoteAccount):void
		{
			super.call(Vector.<String>([BashMethods.GET_REMOTE_KEYS, ra.user, ra.pass]));	
		}	
		
		private function addKeyToRemote(ra:RemoteAccount):void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEY_TO_REMOTE, ra.user, ra.pass]));	
		}	
		
		private function removeKeyFromRemote(ra:RemoteAccount):void
		{
			super.call(Vector.<String>([BashMethods.REMOVE_KEY_FROM_REMOTE, ra.user, ra.pass]));	
		}	
		
		private function repairRemoteKey(ra:RemoteAccount):void
		{
			super.call(Vector.<String>([BashMethods.REPAIR_REMOTE_KEY, ra.user, ra.pass, _ghKeyId]));	
		}	
		
		private function authenticate():void
		{
			super.call(Vector.<String>([BashMethods.AUTHENTICATE, _ghKeyId]));	
		}										
		
	// repsonse handlers //	
	
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			trace("GitHubKeyProxy.onProcessComplete(e)", e.data.method);
			var m:String = e.data.method; var r:String = e.data.result;
			switch(e.data.method){
				case BashMethods.GET_CACHED_KEY_ID :
					onGetCachedKeyId(e.data.result);
				break;
				case BashMethods.GET_REMOTE_KEYS :
					onRemoteKeysReceived(e.data.result);
				break;				
				case BashMethods.ADD_KEY_TO_REMOTE :
					onKeyAddedToRemote(e.data.result);
				break;
				case BashMethods.REPAIR_REMOTE_KEY :
					if (!message(m, r)) onRemoteKeyRepaired();
				break;				
				case BashMethods.REMOVE_KEY_FROM_REMOTE :
					if (!message(m, r)) onKeyRemovedFromRemote();
				break;
				case BashMethods.AUTHENTICATE :
					onKeyAuthenticated(r);
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
		
		private function onGetCachedKeyId(s:String):void
		{
			_ghKeyId = s;
			getRemoteKeys(_primary);
		}		

		private function onRemoteKeysReceived(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				checkKeyIsOnServer(o);
			}	else{
				o.method = BashMethods.GET_REMOTE_KEYS;
				dispatchDebug(o);
			}
		}
		
		private function onKeyAddedToRemote(s:String):void
		{
			var o:Object = getResultObject(s);
			_ghKeyId = o.id;
			authenticate();
		}

		private function onKeyRemovedFromRemote():void
		{
			addKeyToRemote(_primary);	
		}

		private function onRemoteKeyRepaired():void
		{
			dispatchKeyReady();
		}
		
		private function onKeyAuthenticated(s:String):void
		{
			if (s.indexOf("You've successfully authenticated") != -1) dispatchKeyReady();
		}
		
	// helpers //			
		
		private function getResultObject(s:String):Object
		{
			if (s.indexOf('[') == 0 || s.indexOf('{') == 0){
				return new JSONDecoder(s, false).getValue();
			}	else{
				return {result:s};
			}
		}		
		
		private function checkKeyIsOnServer(o:Object):void
		{
			var k:String = SSHProxy.pbKey;
	// strip off username so we can compare against github //			
			k = k.substr(0, k.indexOf('==') + 2);
			for (var i:int = 0; i < o.length; i++) {
				if (o[i].key == k) {
					dispatchKeyReady(); return;
				}	else if (o[i].id == _ghKeyId) {
				// the key has changed //	
					repairRemoteKey(_primary); return;
				}
			}
			addKeyToRemote(_primary);
		}	
		
	// success / failure //	

		private function dispatchKeyReady():void
		{
			dispatchEvent(new AppEvent(AppEvent.PRIMARY_ACCOUNT_SET, _primary));
		}							
		
		private function dispatchDebug(o:Object):void
		{
			o.source = 'GithubKeyProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));			
		}					
		
	}
	
}
