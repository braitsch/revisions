package model.proxies.remote.keys {

	import model.proxies.local.SSHKeyGenerator;
	import model.remote.Account;

	public class BSKeyProxy extends KeyProxy {

		override public function validateKey(ra:Account):void
		{
			super.validateKey(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.user+'.beanstalkapp.com/api';
			super.getAllRemoteKeys('/public_keys.xml');
		}
		
		override public function setPrimaryAccount(n:Account, o:Account = null):void
		{
			super.validateKey(n);
			if (o == null){
				super.getAllRemoteKeys('/public_keys.xml');
			}	else{
				super.deleteKeyFromRemote('/public_keys.xml/'+n.sshKeyId);
			}
		}		
		
		override protected function onRemoteKeysReceived(s:String):void
		{
			var xml:XML = new XML(s);
			var keys:XMLList = xml['public-key'];
			if (keys.length() == 0){
				super.addKeyToRemote(getKeyObject(), '/public_keys.xml');
			}	else{
				for (var i:int = 0; i < keys.length(); i++) {
					if (checkKeysMatch(keys[i].content) == true){
						super.account.sshKeyId = keys[i].id;
						super.dispatchKeyValidated();
					}	else if (super.account.sshKeyId == keys[i].id){
						super.repairRemoteKey('PUT', getKeyObject(), '/public_keys/'+keys[i].id+'.xml');
					}
				}
			}			
		}
		
		override protected function onKeyAddedToAccount(s:String):void
		{
			var xml:XML = new XML(s);			
			super.account.sshKeyId = xml['id'];
			super.authenticate('git@beanstalkapp.com');
		}
		
		override protected function onKeyRemovedFromAccount(s:String):void
		{
			trace("BSKeyProxy.onKeyRemovedFromAccount(s)", s);
		}
		
		private function checkKeysMatch(rk:String):Boolean
		{
		// truncate end so we can compare against github //
			return SSHKeyGenerator.pbKey.substr(0, SSHKeyGenerator.pbKey.indexOf('==') + 2) == rk;	
		}			
		
		private function getKeyObject():String
		{
			var xml:String = '<?xml version="1.0" encoding="UTF-8"?>';
			xml+='<public_key>';
			xml+='<name>'+SSHKeyGenerator.pbKeyName+'</name>';
			xml+='<content>'+SSHKeyGenerator.pbKey+'</content>';
  			xml+='</public_key>';
  			return xml;
		}		
		
	}
	
}
