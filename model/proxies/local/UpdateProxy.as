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
		private static var _timer			:Timer = new Timer(3000);
		private static var _status 			:StatusProxy 	= new StatusProxy();
		private static var _autoSaveQueue	:Vector.<Bookmark> = new Vector.<Bookmark>();

		public function initialize():void
		{
			_timer.addEventListener(TimerEvent.TIMER, onTimerCheckModified);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, onNoBookmarks);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.HISTORY_REQUESTED, onHistoryRequested);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_REQUESTED, onModifiedRequested);
			AppModel.engine.addEventListener(AppEvent.SUMMARY_RECEIVED, onSummaryReceived);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModifiedReceived);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.REVERTED, onBookmarkReverted);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.COMMIT_COMPLETE, onCommitComplete);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
		}

		private function onBranchChanged(e:BookmarkEvent):void {		getHistory();   	}
		private function onHistoryRequested(e:AppEvent):void {			getHistory();		}
		private function onBookmarkReverted(e:BookmarkEvent):void {		getHistory();		}
		private function onBookmarkSelected(e:BookmarkEvent):void { 	getSummary();		}
		
		private function onModifiedRequested(e:AppEvent):void
		{
	// allows us to force check modified before executing a cmd, say like switching branches //	
			getModified(e.data as Bookmark);
		}
		
		private function onTimerCheckModified(e:TimerEvent):void 
		{		
			_autoSaveQueue.length ? getModified(_autoSaveQueue[0]) : getModified(AppModel.bookmark);		
		}		
		
		private function onSummaryReceived(e:AppEvent):void
		{	
			getModified(AppModel.bookmark); 
		}	
		
		private function onModifiedReceived(e:AppEvent):void
		{
			if (_autoSaveQueue.length){
				var b:Bookmark = e.data as Bookmark;
				if (b == _autoSaveQueue[0] && b.branch.isModified){
					_timer.stop(); AppModel.proxies.editor.autoSave(_autoSaveQueue[0]);
				}	else{
					_autoSaveQueue.splice(0, 1);			
				}
			}
		}
		
		private function onCommitComplete(e:BookmarkEvent):void 
		{ 		
			if (_autoSaveQueue.length) {
				if (e.data as Bookmark == _autoSaveQueue[0]) _autoSaveQueue.splice(0, 1);
			}
			getHistory(e.data as Bookmark);
		}							
		
		private function getSummary():void
		{
			resetTimer();
			_status.getSummary();
		}
		
		private function getModified(b:Bookmark):void
		{
			resetTimer();
			if (exists(b)) _status.getModified(b);
		}
		
		private function getHistory(b:Bookmark = null):void
		{
			resetTimer();
		// add slight delay so we have time to display the preloader //	
			setTimeout(_status.getHistory, 500, b || AppModel.bookmark);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Refreshing History'}));
		}
		
		public function autoSave(b:Bookmark):void
		{
			_autoSaveQueue.push(b);
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
		
		private function onNoBookmarks(e:BookmarkEvent):void
		{
			_timer.stop();
		}		
		
		private function resetTimer(e:BookmarkEvent = null):void
		{
			_timer.reset();
			_timer.start();
		}
		
	}
	
}
