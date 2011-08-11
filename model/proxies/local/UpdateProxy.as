package model.proxies.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class UpdateProxy extends EventDispatcher {

	// automatically call getStatus every five seconds // 	
		private static var _timer			:Timer = new Timer(5000);
		private static var _status 			:StatusProxy 	= new StatusProxy();
		private static var _history			:HistoryProxy 	= new HistoryProxy();		
		private static var _working			:Boolean = false;
		private static var _autoSaveQueue	:Array = [];
		private static var _refreshHistory	:Boolean;

		public function initialize():void
		{
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, killTimer);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.HISTORY_REQUESTED, onHistoryRequested);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_REQUESTED, onModifiedRequested);
			AppModel.engine.addEventListener(BookmarkEvent.SUMMARY_RECEIVED, onSummaryReceived);				
			AppModel.proxies.checkout.addEventListener(BookmarkEvent.REVERTED, onBookmarkReverted);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.COMMIT_COMPLETE, onCommitComplete);
			AppModel.proxies.checkout.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
		}

		private function onBranchChanged(e:BookmarkEvent):void {		getSummary(true);   }
		private function onCommitComplete(e:BookmarkEvent):void { 		getHistory();  		}
		private function onHistoryRequested(e:AppEvent):void {			getHistory();		}
		private function onBookmarkReverted(e:BookmarkEvent):void {		getHistory();		}
		private function onBookmarkSelected(e:BookmarkEvent):void { 	getSummary(false);	}
		
		private function onModifiedRequested(e:AppEvent):void
		{
			getModified(e.data as Bookmark);
		}
		
		private function onSummaryReceived(e:BookmarkEvent):void
		{	
			if (_refreshHistory) getHistory(); _refreshHistory = false;
		}					
		
		private function getSummary(b:Boolean):void
		{
			resetTimer();
			_working = true;
			_status.getSummary();
			_refreshHistory = b;
		}
		
		private function getModified(b:Bookmark):void
		{
			resetTimer();
			_working = true;
			_status.getModified(b);
		}
		
		private function getHistory():void
		{
			resetTimer();
			_working = true;
		// add slight delay so we have time to display the preloader //	
			setTimeout(_history.getHistory, 500);
			dispatchEvent(new AppEvent(AppEvent.REQUESTING_HISTORY));			
		}
		
		public function autoSave(b:Bookmark):void
		{
			_autoSaveQueue.push(b);
		//	if (!_working) getModified(_autoSaveQueue[0]);
		}			
		
		private function resetTimer(e:BookmarkEvent = null):void
		{
			_timer.reset();
			_timer.start();
		}
		
		private function killTimer(e:BookmarkEvent):void
		{
			_timer.stop();
		}			
		
	}
	
}