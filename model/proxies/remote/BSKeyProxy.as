package model.proxies.remote {

	import model.proxies.local.SSHKeyGenerator;
	import model.remote.Account;
	import system.BashMethods;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class BSKeyProxy extends KeyProxy {

		private static var _loader		:URLLoader = new URLLoader();
		private static var _baseURL		:String;
		private static var _request		:String;
		
		public function BSKeyProxy() 
		{
			_loader.addEventListener(Event.COMPLETE, onRequestComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestFailure);
			_loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPStatus);
		}

		private function onHTTPStatus(e:HTTPStatusEvent):void
		{
			trace("BSKeyProxy.onHTTPStatus(e)");
			trace(e.status);
			trace(e.responseURL);
			trace(e.responseHeaders);
		}

		override public function validateKey(ra:Account):void
		{
			_account = ra;
			_account.sshKeyId = 666;
			_baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.user+'.beanstalkapp.com/api/';
			getAllRemoteKeys();
		}
		
		private function getAllRemoteKeys():void
		{
			_request = BashMethods.GET_REMOTE_KEYS;
			_loader.load(new URLRequest(_baseURL + 'public_keys.xml'));
		}
		
		private function addKeyToRemote():void
		{
			_request = BashMethods.ADD_KEY_TO_REMOTE;
			var req:URLRequest = new URLRequest(_baseURL + 'public_keys.xml');
				req.data = getKeyXML();
				req.method = URLRequestMethod.POST;
			_loader.load(req);
		}
		
		private function getKeyXML():String
		{
			var xml:String = '<?xml version="1.0" encoding="UTF-8"?>';
			xml+='<public_key><content>';
			xml+=SSHKeyGenerator.pbKey;
  			xml+='</content></public_key>';
  			return xml;
		}
		
		private function onRequestComplete(e:Event):void
		{
			var xml:XML = new XML(_loader.data);
			switch(_request){
				case BashMethods.GET_REMOTE_KEYS :
					onAllRemoteKeysReceived(xml);
				break;
				case BashMethods.ADD_KEY_TO_REMOTE :
					onKeyAddedToRemote(xml);
				break;				
			}
		}

		private function onKeyAddedToRemote(xml:XML):void
		{
			trace("BSKeyProxy.onKeyAddedToRemote(xml) ----!!", xml);
		}

		private function onAllRemoteKeysReceived(xml:XML):void
		{
	//		return;
			if (xml=='') {
				addKeyToRemote();
			}	else{
				dispatchKeyValidated();
			}
		}
		
		private function onRequestFailure(e:IOErrorEvent):void
		{
			trace("BSKeyProxy.onRequestFailure(e)", e);
		}			
		
	}
	
}
