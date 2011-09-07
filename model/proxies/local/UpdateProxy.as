package model.proxies.local {

	import events.AppEvent;
	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class UpdateProxy extends EventDispatcher {

	// automatically call getStatus every five seconds // 	
		private static var _timer			:Timer = new Timer(5000);
		private static var _status 			:StatusProxy 	= new StatusProxy();
		private static var _autoSaveQueue	:Array = [];

		public function initialize():void
		{
			_timer.addEventListener(TimerEvent.TIMER, onTimerCheckModified);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, killTimer);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.HISTORY_REQUESTED, onHistoryRequested);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_REQUESTED, onModifiedRequested);
			AppModel.engine.addEventListener(BookmarkEvent.SUMMARY_RECEIVED, onSummaryReceived);				
			AppModel.proxies.editor.addEventListener(BookmarkEvent.REVERTED, onBookmarkReverted);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.COMMIT_COMPLETE, onCommitComplete);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
		}

		private function onBranchChanged(e:BookmarkEvent):void {		getHistory();   	}
		private function onCommitComplete(e:BookmarkEvent):void { 		getHistory();  		}
		private function onHistoryRequested(e:AppEvent):void {			getHistory();		}
		private function onBookmarkReverted(e:BookmarkEvent):void {		getHistory();		}
		private function onBookmarkSelected(e:BookmarkEvent):void { 	getSummary();		}
		private function onTimerCheckModified(e:TimerEvent):void {		getModified();		}		
		
		private function onModifiedRequested(e:AppEvent):void
		{
	// allows us to force check modified before executing a cmd, say like switching branches //	
			getModified(e.data as Bookmark);
		}
		
		private function onSummaryReceived(e:BookmarkEvent):void
		{	
			getModified(AppModel.bookmark); 
		}					
		
		private function getSummary():void
		{
			resetTimer();
			_status.getSummary();
		}
		
		private function getModified(b:Bookmark = null):void
		{
			resetTimer();
			if (exists(b || AppModel.bookmark)) _status.getModified(b || AppModel.bookmark);
		}
		
		private function getHistory():void
		{
			resetTimer();
		// add slight delay so we have time to display the preloader //	
			setTimeout(_status.getHistory, 500);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Refreshing History'}));
		}
		
		public function autoSave(b:Bookmark):void
		{
			_autoSaveQueue.push(b);
		//	if (!_working) getModified(_autoSaveQueue[0]);
		}
		
		public function set lock(b:Boolean):void
		{	
			b ? _timer.stop() : resetTimer();
		}
		
		private function exists(b:Bookmark):Boolean
		{
			if (b.exists == false){
				_timer.stop();
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.PATH_ERROR, new <Bookmark>[b]));
			}	
			return b.exists;
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
