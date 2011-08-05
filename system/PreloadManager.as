package system {

	import events.AppEvent;
	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import flash.utils.setTimeout;
	public class PreloadManager {

		public function initialize():void
		{
			AppModel.engine.addEventListener(BookmarkEvent.LOADED, onBkmksRendered);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RENDERED, hideLoader);
			AppModel.proxies.update.addEventListener(AppEvent.REQUESTING_HISTORY, onGetHistory);
			AppModel.proxies.editor.addEventListener(AppEvent.INITIALIZING_BOOKMARK, onBookmarkInit);
		}

		private function onBkmksRendered(e:BookmarkEvent):void
		{
			hideLoader(e, 250);
			AppModel.proxies.reader.addEventListener(AppEvent.REPOSITORY_READY, hideLoader);			
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

		private function hideLoader(e:*, d:uint = 0):void
		{
			e = null;
			setTimeout(function():void{AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));}, d);
		}
		
	}
	
}
