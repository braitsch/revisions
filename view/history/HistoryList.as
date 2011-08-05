package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class HistoryList extends Sprite {

		private var _modified			:Boolean;
		private var _branch				:Branch;
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
		
	// on summary & history updates //
		public function checkIfChanged():void
		{
			var m:Boolean = _bookmark.branch.modified;			
			if (_modified != m || numChildren == 0 || _bookmark.branch != _branch){
				_modified = m; _branch = _bookmark.branch; drawList();
			}	else{
				dispatchRenderComplete();		
			}
		}
		
	// private //

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
			var m:Boolean = _bookmark.branch.modified;
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
