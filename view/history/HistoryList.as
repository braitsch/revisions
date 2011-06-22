package view.history {

	import events.UIEvent;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;

	public class HistoryList extends Sprite {

		private var _bookmark			:Bookmark;
		private var _modified			:Number;
		private var _unsaved			:HistoryItemUnsaved;

		public function HistoryList($bkmk:Bookmark)
		{
			_bookmark = $bkmk;
			_unsaved = new HistoryItemUnsaved();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
	// public //	
		
		public function get bookmark():Bookmark
		{
			return _bookmark;
		}
		
		public function checkIfModified():void
		{
			if (isNaN(_modified)) {
				_modified = _bookmark.branch.modified;
				if (_bookmark.branch.history != null) sortList();
			}	else if (_bookmark.branch.modified != _modified) {
				_modified = _bookmark.branch.modified;
				if (_bookmark.branch.history != null) sortList();
			}			
		}
		
		public function drawList(reset:Boolean):void
		{
			if (reset) _modified = 0;
			while(numChildren) removeChildAt(0);
			var a:Vector.<Commit> = _bookmark.branch.history;
			for (var i:int = 0; i < a.length; i++) {
				addChild(new HistoryItemSaved(a[i], _bookmark.branch.totalCommits-i));
			}
			sortList();						
		}
		
	// private //
	
		private function sortList():void
		{
			if (_modified > 0) {
				addChildAt(_unsaved, 0);
			}	else if (_modified == 0 && _unsaved.stage) {
				removeChildAt(0);
			}
			for (var i:int = 0; i < numChildren; i++) {
				var k:HistoryItem = getChildAt(i) as HistoryItem;
				k.y = i * 30;
				k.resize(stage.stageWidth - 204);
				TweenLite.from(getChildAt(i), .2, {alpha:0, delay:i*.05});
			}
			dispatchEvent(new UIEvent(UIEvent.HISTORY_DRAWN));
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
