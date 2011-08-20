package model.proxies.remote.keys {

	import model.proxies.local.SSHKeyGenerator;
	import model.remote.Account;
	
	public class GHKeyProxy extends KeyProxy {
		
		override public function validateKey(ra:Account):void
		{
			super.validateKey(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@api.github.com';
			super.getAllRemoteKeys('/user/keys');
		}
		
		override public function setPrimaryAccount(n:Account, o:Account = null):void
		{
			super.validateKey(n);
			if (o == null){
				super.getAllRemoteKeys('/user/keys');
			}	else{
				super.deleteKeyFromRemote('/user/keys/'+n.sshKeyId);
			}
		}
		
		override protected function onRemoteKeysReceived(s:String):void
		{
			var a:Array = getResultObject(s) as Array;
			if (a.length == 0){
				super.addKeyToRemote(getKeyObject(), '/user/keys');
			}	else{
				for (var i:int = 0; i < a.length; i++) {
					if (checkKeysMatch(a[i].key) == true){
						super.account.sshKeyId = a[i].id;
						super.dispatchKeyValidated();
					}	else if (super.account.sshKeyId == a[i].id){
						super.repairRemoteKey('PATCH', getKeyObject(), '/user/keys/'+a[i].id);
					}
				}
			}
		}
		
		override protected function onKeyAddedToAccount(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				super.account.sshKeyId = o.id;
				super.authenticate('git@github.com');
			}	else {
				super.account.sshKeyId = 0;
				super.dispatchKeyValidated();
				trace("SSHKeyProxy.onKeyAddedToRemote(s) - problem adding key to remote server, key probably already exists");
			}
		}
		
		override protected function onKeyRemovedFromAccount(s:String):void
		{
			super.getAllRemoteKeys('/user/keys');
			trace("GHKeyProxy.onKeyRemovedFromAccount(s)", s);
		}
		
		private function checkKeysMatch(rk:String):Boolean
		{
		// truncate end so we can compare against github //
			return SSHKeyGenerator.pbKey.substr(0, SSHKeyGenerator.pbKey.indexOf('==') + 2) == rk;	
		}						
		
		private function getKeyObject():String
		{
			return '{"title":"'+SSHKeyGenerator.pbKeyName+'", "key":"'+SSHKeyGenerator.pbKey+'"}';
		}		
		
	}
	
}
