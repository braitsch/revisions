package model.proxies.remote.keys {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.CurlProxy;
	import model.remote.HostingAccount;
	import system.BashMethods;

	public class KeyProxy extends CurlProxy {

		private static var _baseURL		:String;
		private static var _account		:HostingAccount;

		protected function get account()				:HostingAccount 	{ return _account; 		}
		protected function set baseURL(baseURL:String)	:void 				{ _baseURL = baseURL; 	}
		protected function set account(a:HostingAccount):void 				{ _account = a; 		}
		
		public function KeyProxy()
		{
			super.executable = 'Account.sh';
		}
		
		public function addKeyToAccount(u:String, p:String, a:String):void { }
		public function checkKey(ra:HostingAccount):void { }
	// called from subclasses //	
		
		protected function getAllRemoteKeys(url:String):void
		{
			startTimer();
			super.request = BashMethods.GET_REMOTE_KEYS;
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));
		}
		
		protected function addKeyToRemote(header:String, data:String, url:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_KEY_TO_REMOTE;
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));
		}
		
		protected function repairRemoteKey(vrb:String, key:String, url:String):void
		{
			startTimer();
			trace("KeyProxy.repairRemoteKey(vrb, key, url)", key, _baseURL + url);
			super.request = BashMethods.REPAIR_REMOTE_KEY;
			super.call(Vector.<String>([vrb=='PUT' ? BashMethods.PUT_REQUEST : BashMethods.PATCH_REQUEST, key, _baseURL + url]));			
		}	
		
		protected function deleteKeyFromRemote(url:String):void
		{
			startTimer();
			super.request = BashMethods.DELETE_KEY_FROM_REMOTE;
			super.call(Vector.<String>([BashMethods.DELETE_REQUEST, _baseURL + url]));
		}
		
		protected function addToKnownHosts(h:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_NEW_KNOWN_HOST;
			super.call(Vector.<String>([BashMethods.ADD_NEW_KNOWN_HOST, h]));			
		}
		
		override protected function onProcessSuccess(r:String):void
		{
			switch(super.request){
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.REMOTE_KEY_READY));
	//		AppModel.database.setSSHKeyId(_account); 
		}
		
	}
	
}
