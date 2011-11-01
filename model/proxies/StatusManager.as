package model.proxies {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.local.StatusProxy;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class StatusManager {

		private static var _timer			:Timer = new Timer(3000);
		private static var _ticks			:uint = 0;
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
			b ? stopTimers() : resetTimer();
		}

		public function get locked():Boolean
		{
			if (AppModel.bookmark == null){
				return false;
			}	else{
				return _timer.running == false;
			}
		}	
	
	// private methods //

		private function initTimers():void
		{
			_timer.addEventListener(TimerEvent.TIMER, onTimerCheckModified);			
		}
		
		private function addListeners():void
		{
			AppModel.engine.addEventListener(AppEvent.NO_BOOKMARKS, onNoBookmarks);
			AppModel.engine.addEventListener(AppEvent.BOOKMARK_SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.GET_BRANCH_HISTORY, getBranchHistory);
			AppModel.engine.addEventListener(AppEvent.HISTORY_REQUESTED, onHistoryRequested);
			AppModel.engine.addEventListener(AppEvent.SUMMARY_RECEIVED, onSummaryReceived);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModifiedReceived);
			AppModel.engine.addEventListener(AppEvent.BRANCH_CHANGED, onBranchChanged);
			AppModel.engine.addEventListener(AppEvent.COMMIT_COMPLETE, onCommitComplete);
			AppModel.engine.addEventListener(AppEvent.BRANCH_PUSHED, onBranchSynced);
			AppModel.engine.addEventListener(AppEvent.HISTORY_REVERTED, onHistoryReverted);
		}

		private function onBranchSynced(e:AppEvent):void 		{ 	getHistory();		}
		private function onBranchChanged(e:AppEvent):void 		{	getHistory();   	}
		private function onHistoryRequested(e:AppEvent):void	{	getHistory();		}
		private function onHistoryReverted(e:AppEvent):void 	{ 	getHistory();		}
		private function onBookmarkSelected(e:AppEvent):void 	{ 	getSummary();		}
		
		private function onTimerCheckModified(e:TimerEvent):void 
		{		
			_autoSaveQueue.length ? getModified(_autoSaveQueue[0]) : getModified(AppModel.bookmark);		
		}
		
		private function getModified(b:Bookmark):void
		{
			resetTimer();
			if (exists(b) == true) _proxy.getModified(b);
		}
		
		private function getSummary():void
		{
			if (exists(AppModel.bookmark)){
				resetTimer();
				_ticks = 0; _proxy.getSummary();
			}
		}
		
		private function getHistory():void
		{
			if (exists(AppModel.bookmark)){
				resetTimer();
		// add slight delay so we have time to display the preloader //	
				AppModel.showLoader('Refreshing History');
				setTimeout(_proxy.getHistory, 500);
			}
		}
		
		private function getBranchHistory(e:AppEvent):void
		{
			resetTimer();
			_proxy.getBranchHistory(e.data as Branch);	
		}		
		
		private function getRemoteStatus(fetch:Boolean = false):void
		{
			if (AppModel.repository) {
				if (exists(AppModel.bookmark) == true){
					resetTimer(); 
					if (AppModel.repository.hasBranch(AppModel.branch.name)){
						fetch ? AppModel.proxies.sync.fetchRepository() : _proxy.getRemoteStatus();
					}
				}
			}
		}
		
	// request callbacks //	
	
		private function onSummaryReceived(e:AppEvent):void 		
		{	
			getModified(AppModel.bookmark);	
		}		
		
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
			getRemoteStatus(++_ticks % 4 == 0);
		}
		
		private function onCommitComplete(e:AppEvent):void 
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
				AppModel.dispatch(AppEvent.PATH_ERROR, b);
				return false;
			}
		}
		
		private function onNoBookmarks(e:AppEvent):void
		{
			stopTimers();
		}		
		
		private function stopTimers():void
		{
			_timer.stop();
		}
		
		private function resetTimer():void
		{
			_timer.reset(); _timer.start();
		}		
		
	}
	
}
