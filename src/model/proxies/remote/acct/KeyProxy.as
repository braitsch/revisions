package model.proxies.remote.acct {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import system.BashMethods;

	public class KeyProxy extends CurlProxy {

		private static var _baseURL		:String;
		private static var _account		:HostingAccount;

		protected function get account()				:HostingAccount 	{ return _account; 		}
		protected function set baseURL(baseURL:String)	:void 				{ _baseURL = baseURL; 	}
		protected function set account(a:HostingAccount):void 				{ _account = a; 		}
		
		public function checkKey(ra:HostingAccount):void { }
		
	// called from subclasses //	
		
		protected function getAllRemoteKeys(url:String):void
		{
			super.call(Vector.<String>([BashMethods.GET_REMOTE_KEYS, _baseURL + url]));
		}
		
		protected function addKeyToRemote(data:String, url:String):void
		{
			super.call(Vector.<String>([BashMethods.ADD_KEY_TO_REMOTE, data, _baseURL + url]));
		}
		
		protected function repairRemoteKey(key:String, url:String):void
		{
			super.call(Vector.<String>([BashMethods.REPAIR_REMOTE_KEY, key, _baseURL + url]));			
		}	
		
		protected function deleteKeyFromRemote(url:String):void
		{
			super.call(Vector.<String>([BashMethods.DELETE_KEY_FROM_REMOTE, _baseURL + url]));
		}
		
		protected function addToKnownHosts(h:String):void
		{
			super.call(Vector.<String>([BashMethods.ADD_NEW_KNOWN_HOST, h]));			
		}
		
		override protected function onProcessSuccess(m:String, r:String):void
		{
			switch(m){
				case BashMethods.GET_REMOTE_KEYS :
					onRemoteKeysReceived(r);
				break;
				case BashMethods.ADD_KEY_TO_REMOTE :
					onKeyAddedToAccount(r);
				break;
				case BashMethods.REPAIR_REMOTE_KEY : 
					dispatchKeyValidated();
				break;	
				case BashMethods.DELETE_KEY_FROM_REMOTE :
					onKeyRemovedFromAccount(r);
				break;
				case BashMethods.ADD_NEW_KNOWN_HOST :
					dispatchKeyValidated();
				break;
			}			
		}

	// callbacks //
		
		protected function onRemoteKeysReceived(r:String):void { }
		
		protected function onKeyAddedToAccount(r:String):void { }

		protected function onKeyRemovedFromAccount(r:String):void { }

		protected function dispatchKeyValidated():void 
		{ 
			dispatchEvent(new AppEvent(AppEvent.REMOTE_KEY_READY, _account));
		}
		
	}
	
}
