package system {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	public class PreloadManager {

		public function initialize():void
		{
			AppModel.engine.addEventListener(AppEvent.HISTORY_RENDERED, hideLoader);
			AppModel.proxies.history.addEventListener(AppEvent.REQUESTING_HISTORY, onGetHistory);
			AppModel.proxies.reader.addEventListener(AppEvent.REPOSITORY_READY, hideLoader);
			AppModel.proxies.editor.addEventListener(AppEvent.INITIALIZING_BOOKMARK, onBookmarkInit);
		}

		private function onBookmarkInit(e:AppEvent):void
		{
			var s:String = Bookmark(e.data).type == Bookmark.FILE ? 'File' : 'Directory Contents';
			showLoader('Reading '+s);
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
