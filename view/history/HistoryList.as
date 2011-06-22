package view.history {

	import events.UIEvent;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;

	public class HistoryList extends Sprite {

		private var _hLength			:uint;	// cached history length
		private var _mLength			:uint;	// cached modified length
		private var _bookmark			:Bookmark;
		private var _unsaved			:HistoryItemUnsaved;

		public function HistoryList($bkmk:Bookmark)
		{
			_bookmark = $bkmk;
			_unsaved = new HistoryItemUnsaved();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
	// public //	
		
		public function get bookmark():Bookmark { return _bookmark; }
		
	// on status, summary & history updates //
		public function checkIfChanged():void
		{
			if (_bookmark.branch.history == null) return;
			var h:Boolean = historyHasChanged();
			var m:Boolean = modifiedHasChanged();
			if (h == true) {
				drawList();
			}	else if (m == true){
				sortList();
			}	else{
		// dispatch event to kill the preloader //		
				dispatchEvent(new UIEvent(UIEvent.HISTORY_DRAWN));				
			}
		}

	// private //

		private function modifiedHasChanged():Boolean
		{
			var n:uint = _bookmark.branch.modified.length;
			if (isNaN(_mLength) || _mLength != n) {
				_mLength = n;
				return true;
			}	else{
				return false;
			}
		}
		
		private function historyHasChanged():Boolean
		{
			var h:uint = _bookmark.branch.history.length;			
			if (isNaN(_hLength) || _hLength != h) {
				_hLength = h;
				return true;
			}	else{
				return false;
			}
		}
		
		private function drawList():void
		{
			while(numChildren) removeChildAt(0);
			var v:Vector.<Commit> = _bookmark.branch.history;
			for (var i:int = 0; i < v.length; i++) addChild(new HistoryItemSaved(v[i]));
			sortList();						
		}
		
		private function sortList():void
		{
			showHideUnsaved();
			for (var i:int = 0; i < numChildren; i++) {
				var k:HistoryItem = getChildAt(i) as HistoryItem;
				k.y = i * 30;
				if (stage) k.resize(stage.stageWidth - 204);
				TweenLite.from(getChildAt(i), .2, {alpha:0, delay:i*.05});
			}
			dispatchEvent(new UIEvent(UIEvent.HISTORY_DRAWN));
		}
		
		private function showHideUnsaved():void
		{
			if (_mLength > 0) {
				addChildAt(_unsaved, 0);
			}	else if (_mLength == 0 && _unsaved.stage) {
				removeChildAt(0);
			}				
		}
		
		private function onAddedToStage(e:Event):void
		{
			resize();
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resize);
		}

		private function resize(e:Event = null):void
		{
			for (var i:int = 0; i < numChildren; i++) HistoryItem(getChildAt(i)).resize(stage.stageWidth - 204);
		}	
		
	}
	
}
