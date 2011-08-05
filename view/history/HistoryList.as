package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Commit;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class HistoryList extends Sprite {

		private var _hLength			:uint;		// cached history length
		private var _modified			:Boolean;
		private var _bookmark			:Bookmark;
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList($bkmk:Bookmark)
		{
			_bookmark = $bkmk;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
	// public //	
		
		public function get bookmark():Bookmark { return _bookmark; }
		
	// on status, summary & history updates //
		public function checkIfChanged():void
		{
			trace("HistoryList.checkIfChanged()");
			var h:Boolean = historyHasChanged();
			trace('h: ' + (h));
			var m:Boolean = modifiedHasChanged();
			trace('m: ' + (m));
			if (h == true) {
				drawList();
			}	else if (m == true){
				sortList();
			}	else{
				dispatchRenderComplete();				
			}
		}

	// private //

		private function modifiedHasChanged():Boolean
		{
			var m:Boolean = _bookmark.branch.isModified();
			if (_modified != m) {
				_modified = m;
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
			dispatchRenderComplete();
		}
		
		
		private function dispatchRenderComplete():void
		{
		// add slight delay so the list has time to finish drawing itself //	
			setTimeout(function():void{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HISTORY_RENDERED));
			}, 500);
		}		
		
		private function showHideUnsaved():void
		{
			var m:Boolean = _bookmark.branch.isModified();
			if (m == true) {
				addChildAt(_itemUnsaved, 0);
			}	else if (m == false && _itemUnsaved.stage) {
				removeChildAt(0);
			}				
		}
		
	// adjust list items on stage resizing //	
		
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
