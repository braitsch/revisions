package model.proxies {

	import events.NativeProcessEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.air.NativeProcessProxy;
	import system.BashMethods;

	public class CheckoutProxy extends NativeProcessProxy {

		public function CheckoutProxy()
		{
			super.executable = 'Checkout.sh';
			super.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);					
			super.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
		}
		
		public function revert(sha1:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.REVERT_TO_VERSION, sha1]));			
		}
		
		public function download(sha1:String, saveAs:String, file:String):void
		{
			super.directory = AppModel.bookmark.gitdir;
			super.call(Vector.<String>([BashMethods.DOWNLOAD_VERSION, sha1, saveAs, file]));
		}
		
		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method) {
			// auto update the history after reverting to an earlier version //	
				case BashMethods.REVERT_TO_VERSION : AppModel.proxies.history.getHistory();	break;
			}
		}
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			var m:String = 'Sorry, it looks like there was a problem! \n';
			m+='CheckoutProxy.onProcessFailure(e) \n';
			m+='Method "'+e.data.method+'" failed \n';
			m+='Message: '+e.data.result;
			AppModel.engine.dispatchEvent(new UIEvent(UIEvent.SHOW_ALERT, m));
		}
		
	}
	
}
