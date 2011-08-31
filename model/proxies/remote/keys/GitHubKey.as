package model.proxies.remote.keys {

	import model.proxies.local.SSHKeyGenerator;
	import model.remote.HostingAccount;
	
	public class GitHubKey extends KeyProxy {
		
		override public function checkKey(ra:HostingAccount):void
		{
			super.account = ra;
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@api.github.com';
			super.getAllRemoteKeys('/user/keys');
		}
		
	// private methods //		
		
		override protected function onRemoteKeysReceived(s:String):void
		{
			var a:Array = getResultObject(s) as Array;
			if (a.length == 0){
				super.addKeyToRemote(HEADER_TXT, getKeyObject(), '/user/keys');
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
		//		super.authenticate('git@github.com');
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
