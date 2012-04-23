package error {
	import events.AppEvent;

	import model.AppModel;
	import model.vo.Bookmark;

	import view.windows.modals.system.Debug;

	import flash.events.EventDispatcher;

	public class AppError extends EventDispatcher {
		
		public var source	:String;
		public var result 	:String;
		public var method 	:String;
		public var message 	:String;	
		public var bookmark	:Bookmark;
		
		public function AppError(o:Object, b:Bookmark, s:String) {
			for (var k:String in o) this[k] = o[k];
			this.source = s; this.bookmark = b; o = null;
		}
		
		static public function resolve(e:AppError):void
		{
			if (e.result.search('fatal: Not a git repository') != -1){
				AppModel.engine.addEventListener(AppEvent.BOOKMARK_DELETED, onBkmkDeleted);				
				AppModel.engine.deleteBookmark(e.bookmark, false, false);
			}	else{
				trace("AppError.resolve(e)", e.result);
				var d:Debug = new Debug(e);
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, d));
			}
		}

		private static function onBkmkDeleted(e:AppEvent):void 
		{
			AppModel.engine.removeEventListener(AppEvent.BOOKMARK_DELETED, onBkmkDeleted);
		}
		
	}
	
}
