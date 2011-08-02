package system {

	import events.AppEvent;
	import model.AppModel;
	public class PreloadManager {

		public function initialize():void
		{
			AppModel.engine.addEventListener(AppEvent.HISTORY_RENDERED, hideLoader);
			AppModel.proxies.history.addEventListener(AppEvent.REQUESTING_HISTORY, onGetHistory);
		}

		private function onGetHistory(e:AppEvent):void
		{
			showLoader('Refreshing History');	
		}
		
	// show, hide & update loader //	
		
		private function showLoader(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, m));
		}

		private function hideLoader(e:AppEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));				
		}
		
	}
	
}
