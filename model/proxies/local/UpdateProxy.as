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

		private static var _status			:Timer = new Timer(3000);
		private static var _remote			:Timer = new Timer(9999);
		private static var _proxy 			:StatusProxy = new StatusProxy();
		private static var _autoSaveQueue	:Vector.<Bookmark> = new Vector.<Bookmark>();

		public function initialize():void
		{
			initTimers();
			addListeners();
		}
		
		public function autoSave(b:Bookmark):void
		{
			_autoSaveQueue.push(b);
		}
		
		public function set locked(b:Boolean):void
		{	
			b ? stopTimers() : startTimers();
		}

		public function get locked():Boolean
		{
			if (AppModel.bookmark == null){
				return false;
			}	else{
				return _status.running == false;
			}
		}	
	
	// private methods //		

		private function initTimers():void
		{
			_remote.addEventListener(TimerEvent.TIMER, onTimerFetchRemote);
			_status.addEventListener(TimerEvent.TIMER, onTimerCheckModified);			
		}
		
		private function addListeners():void
		{
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, onNoBookmarks);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.HISTORY_REQUESTED, onHistoryRequested);
			AppModel.engine.addEventListener(AppEvent.SUMMARY_RECEIVED, onSummaryReceived);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModifiedReceived);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.REVERTED, onBookmarkReverted);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
			AppModel.proxies.editor.addEventListener(BookmarkEvent.COMMIT_COMPLETE, onCommitComplete);			
		}

		private function onBranchChanged(e:BookmarkEvent):void 		{	getHistory();   	}
		private function onHistoryRequested(e:AppEvent):void		{	getHistory();		}
		private function onBookmarkReverted(e:BookmarkEvent):void 	{	getHistory();		}
		private function onBookmarkSelected(e:BookmarkEvent):void 	{ 	getSummary();		}
		
		private function onTimerFetchRemote(e:TimerEvent):void
		{
			getRemoteStatus();
		}				
		
		private function onTimerCheckModified(e:TimerEvent):void 
		{		
			_autoSaveQueue.length ? getModified(_autoSaveQueue[0]) : getModified(AppModel.bookmark);		
		}
		
		private function getRemoteStatus():void
		{
			resetFetchTimer(); 
			if (exists(AppModel.bookmark) == true && AppModel.bookmark.remotes.length) _proxy.fetchRemote();
		}
		
		private function onSummaryReceived(e:AppEvent):void 		
		{	
			getModified(AppModel.bookmark);		
		}		
		
		private function getModified(b:Bookmark):void
		{
			resetStatusTimer();
			if (exists(b) == true) _proxy.getModified(b);
		}
		
		private function getSummary():void
		{
			resetStatusTimer();
			_proxy.getSummary();
		}
		
		private function getHistory():void
		{
			resetStatusTimer();
		// add slight delay so we have time to display the preloader //	
			setTimeout(_proxy.getHistory, 500);
			AppModel.showLoader('Refreshing History');
		}
		
	// autoSave callbacks //	
		
		private function onModifiedReceived(e:AppEvent):void
		{
			if (_autoSaveQueue.length){
				var b:Bookmark = e.data as Bookmark;
				if (b == _autoSaveQueue[0] && b.branch.isModified){
					stopTimers(); AppModel.proxies.editor.autoSave(_autoSaveQueue[0]);
				}	else{
					_autoSaveQueue.splice(0, 1);			
				}
			}
			if (isNaN(AppModel.branch.remoteStatus)) getRemoteStatus();
		}
		
		private function onCommitComplete(e:BookmarkEvent):void 
		{ 		
			if (_autoSaveQueue.length) {
				if (e.data as Bookmark == _autoSaveQueue[0]) _autoSaveQueue.splice(0, 1);
			}
			getHistory();
		}		
		
		private function exists(b:Bookmark):Boolean
		{
			if (b.exists){
				return true;
			}	else{
				stopTimers();
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.PATH_ERROR, b));
				return false;
			}
		}
		
		private function onNoBookmarks(e:BookmarkEvent):void
		{
			stopTimers();
		}		
		
		private function stopTimers():void
		{
			_status.stop();
			_remote.stop();		
		}
		
		private function startTimers():void
		{
			_status.reset(); _status.start();
			_remote.reset(); _remote.start();
		}		
		
		private function resetStatusTimer():void
		{
			_status.reset(); _status.start();
		}
		
		private function resetFetchTimer():void
		{
			_remote.reset(); _remote.start();	
		}
		
	}
	
}
