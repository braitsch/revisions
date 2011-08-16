package model.proxies.remote {

	import events.AppEvent;
	import events.NativeProcessEvent;
	import model.proxies.local.SSHKeyGenerator;
	import model.remote.RemoteAccount;
	import system.BashMethods;

	public class SSHKeyProxy extends RemoteProxy {

		private static var _account		:RemoteAccount;

		public function SSHKeyProxy()
		{
			super.executable = 'SSHKeyValidator.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function validateKey(n:RemoteAccount):void
		{
			_account = n;
			getAllRemoteKeys();
		}		
		
		public function setPrimaryAccount(n:RemoteAccount, o:RemoteAccount = null):void
		{
			_account = n;
			if (o == null){
				getAllRemoteKeys();		
			}	else{
				deleteKeyFromRemote(o);
			}
		}
		
		private function getAllRemoteKeys():void
		{
			super.call(Vector.<String>([BashMethods.GET_ALL_REMOTE_KEYS, _account.user, _account.pass]));	
		}
		
		private function repairRemoteKey():void
		{
			super.call(Vector.<String>([BashMethods.REPAIR_REMOTE_KEY, _account.user, _account.pass, _account.sshKeyId]));	
		}	
		
		private function addKeyToRemote():void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEY_TO_REMOTE, _account.user, _account.pass]));
		}
		
		private function deleteKeyFromRemote(ra:RemoteAccount):void
		{
			super.call(Vector.<String>([BashMethods.DELETE_KEY_FROM_REMOTE, ra.user, ra.pass, ra.sshKeyId]));
		}
		
		private function authenticate():void
		{
			super.call(Vector.<String>([BashMethods.AUTHENTICATE]));
		}					

		private function onProcessComplete(e:NativeProcessEvent):void
		{
			var m:String = e.data.method;
			var r:String = e.data.result;
			switch(e.data.method){
				case BashMethods.GET_ALL_REMOTE_KEYS :
					onAllRemoteKeysReceived(r);
				break;
				case BashMethods.ADD_KEY_TO_REMOTE :
					onKeyAddedToRemote(r);
				break;
				case BashMethods.REPAIR_REMOTE_KEY :
					if (!message(m, r)) dispatchKeyValidated();
				break;				
				case BashMethods.DELETE_KEY_FROM_REMOTE :
					addKeyToRemote();
				break;
				case BashMethods.AUTHENTICATE :
					dispatchKeyValidated();
				break;
			}
		}
		
	// callbacks //

		private function onAllRemoteKeysReceived(s:String):void
		{
			var a:Array = getResultObject(s) as Array;
			if (a.length == 0){
				addKeyToRemote();	
			}	else{
				for (var i:int = 0; i < a.length; i++) {
					if (checkKeysMatch(a[i].key) == true){
						_account.sshKeyId = a[i].id;
						dispatchKeyValidated();
					}	else if (_account.sshKeyId == a[i].id){
						repairRemoteKey();
					}
				}
			}
		}

		private function onKeyAddedToRemote(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				_account.sshKeyId = o.id;
				authenticate();
			}	else {
				_account.sshKeyId = 0;
				dispatchKeyValidated();
				trace("SSHKeyProxy.onKeyAddedToRemote(s) - problem adding key to remote server, key probably already exists");
			}
		}
		
		private function checkKeysMatch(rk:String):Boolean
		{
		// truncate end so we can compare against github //
			return SSHKeyGenerator.pbKey.substr(0, SSHKeyGenerator.pbKey.indexOf('==') + 2) == rk;	
		}
		
		private function dispatchKeyValidated():void
		{
			dispatchEvent(new AppEvent(AppEvent.REMOTE_KEY_SET, _account));			
		}		
		
	}
	
}
