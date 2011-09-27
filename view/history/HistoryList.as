package view.history {

	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import com.greensock.TweenLite;
	import flash.display.Sprite;

	public class HistoryList extends Sprite {

		private var _length				:uint;
		private var _modified			:Boolean;
		private var _branch				:Branch;
		private var _bookmark			:Bookmark;
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList($bkmk:Bookmark)
		{
			_bookmark = $bkmk;
		}
		
	// public //	
		
		public function get bookmark():Bookmark { return _bookmark; }
		
	// on summary & history updates //
		public function checkIfChanged():void
		{
			var m:Boolean = _bookmark.branch.isModified;
			var n:uint = _bookmark.branch.history.length;
			if (_length != n || _modified != m || numChildren == 0 || _bookmark.branch != _branch){
				_length = n; _modified = m; 
				_branch = _bookmark.branch; 
				drawList();
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
					k.y = i * 41;
				TweenLite.from(k, .2, {alpha:0, delay:i*.05});
			}
		}
		
		private function showHideUnsaved():void
		{
			var m:Boolean = _bookmark.branch.isModified;
			if (m == true) {
				addChildAt(_itemUnsaved, 0);
			}	else if (m == false && _itemUnsaved.stage) {
				removeChildAt(0);
			}				
		}
		
	}
	
}
