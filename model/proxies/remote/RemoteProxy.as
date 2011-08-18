package model.proxies.remote {

	import events.AppEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import com.adobe.serialization.json.JSONDecoder;

	public class RemoteProxy extends NativeProcessProxy {

		protected function message(m:String, r:String):Boolean
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
		
		protected function getResultObject(s:String):Object
		{
		// strip off any post headers we receive before parsing json //	
			var k:String = s.charAt(s.length - 1);
			if (k == '}'){
				return new JSONDecoder(s.substr(s.indexOf('{')), false).getValue();
			}	else if (k == ']'){
				return new JSONDecoder(s.substr(s.indexOf('[')), false).getValue();
			}	else{
				return {result:s};
			}					
		}
		
		protected function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}			
		
		protected function dispatchDebug(o:Object):void
		{
			o.source = 'RemoteProxy.onProcessFailure(e)';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_DEBUG, o));			
		}							
		
	}
	
}
