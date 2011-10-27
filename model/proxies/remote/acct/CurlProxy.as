package model.proxies.remote.acct {

	import events.ErrEvent;
	import events.NativeProcessEvent;
	import model.proxies.remote.RemoteProxy;
	import com.adobe.serialization.json.JSONDecoder;

	public class CurlProxy extends RemoteProxy {
		
		protected function getResultObject(s:String):Object
		{
		// strip off any post headers we receive before parsing github json //	
			var k:String = s.charAt(s.length - 1);
			if (k == '}'){
				return new JSONDecoder(s.substr(s.indexOf('{')), false).getValue();
			}	else if (k == ']'){
				return new JSONDecoder(s.substr(s.indexOf('[')), false).getValue();
			}	else{
				return {result:s};
			}					
		}
		
		override protected function onProcessComplete(e:NativeProcessEvent):void
		{
			super.onProcessComplete(e);
			var s:String = e.data.result; 
			var r:String = s.substr(s.indexOf(',') + 1);
			var x:uint = uint(s.substr(0, s.indexOf(',')));
			if (x == 0){
				onProcessSuccess(e.data.method, r);
			}	else{
				onProcessFailure(x, e.data.method);		
			}
		}
		
		protected function onProcessSuccess(m:String, r:String):void { }
		
		private function onProcessFailure(x:uint, m:String):void
		{
			switch(x){
				case 6 :
					dispatchError(ErrEvent.NO_CONNECTION);
				break;
				case 7 :
					dispatchError(ErrEvent.SERVER_FAILURE);
				break;
				default :
			// handle any other mysterious errors we get back from curl //
				dispatchDebug({method:m, message:'Request failed with exit code : '+x});
			}
		}
		
	}
	
}
