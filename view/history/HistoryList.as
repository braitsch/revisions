package view.history {

	import events.UIEvent;
	import events.BookmarkEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import model.vo.Bookmark;
	import model.vo.Commit;

	public class HistoryList extends Sprite {

		private var _bookmark			:Bookmark;
		private var _modified			:uint;
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
		
		public function onStatus():void
		{
		// don't draw if the user hasn't requested the history yet.	
			if (_bookmark.branch.history == null) return;
		// only rebuild if the # of modified files has changed //
			if (_bookmark.branch.modified != _modified) {
				_modified = _bookmark.branch.modified;
				drawList();
			}
		}
		
		public function onHistory():void { drawList(); }
		
	// private //

		private function drawList(e:BookmarkEvent = null):void
		{
			while(numChildren) removeChildAt(0);
			if (_modified) addChild(_unsaved);
			
			var a:Array = _bookmark.branch.history;
			for (var i:int = 0; i < a.length; i++) {
				var o:Object = {	index : String(a.length-i),
									date 	: a[i][1],
									author 	: a[i][2],
									note 	: a[i][3],
									sha1 	: a[i][0],
									branch 	: _bookmark.branch};
				var item:HistoryItemSaved = new HistoryItemSaved(new Commit(o));
					item.y = numChildren * 30;
					item.resize(stage.stageWidth - 204);
				addChild(item);
			}
			_unsaved.resize(stage.stageWidth - 204);
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
			for (var i:int = 0; i < numChildren; i++) {
				HistoryItem(getChildAt(i)).resize(stage.stageWidth - 204);
			}	
		}	
		
	}
	
}
