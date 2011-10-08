package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import view.ui.ScrollingList;
	import com.greensock.TweenLite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class HistoryList extends ScrollingList {

		private var _delay				:uint;
		private var _width				:uint;
		private var _height				:uint;
		private var _length				:uint;
		private var _modified			:Boolean;
		private var _branch				:Branch;
		private var _bookmark			:Bookmark;
		private var _itemsSaved			:Vector.<HistoryItemSaved> = new Vector.<HistoryItemSaved>();
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList()
		{
			super.leading = 41;
			super.bottomPadding = -1;
			for (var i:int = 0; i < 25; i++) _itemsSaved.push(new HistoryItemSaved());
		}

		public function set bookmark(b:Bookmark):void
		{
			clearTimeout(_delay);
			if (b == null){
				collapseList(); _bookmark = null;
			}	else {
				_delay = setTimeout(checkIfChanged, 500, b);
			}
		}
		
		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			super.draw(_width, _height);
			for (var i:int = 0; i < super.list.numChildren; i++) HistoryItem(super.list.getChildAt(i)).setSize(_width, 41);
		}
		
		private function checkIfChanged(bk:Bookmark):void
		{
			var b:Branch =  bk.branch;
			var k:Bookmark =  bk;
			var h:uint = bk.branch.history.length;
			var m:Boolean = bk.branch.isModified;
			if (_bookmark != k || _branch != b || _length != h || _modified != m){
				_bookmark = k; _branch = b; _length = h; _modified = m;
				drawList();
			}	else{
				dispatchHistoryRendered();
			}
		}

		private function drawList():void
		{
			if (_modified){
				super.showItem(_itemUnsaved, 0, 0);
			}	else{
				super.hideItem(_itemUnsaved, 0, 0);
			}
			var v:Vector.<Commit> = _branch.history;
			for (var i:int = 0; i < 25; i++) {
				if (i < v.length){
					_itemsSaved[i].commit = v[i];
					super.showItem(_itemsSaved[i], _modified ? i + 1 : i);
				}	else{
					super.hideItem(_itemsSaved[i], super.list.numChildren - i);
				}
				_itemsSaved[i].y = 41 * (_modified ? i + 1 : i);
			}
			setSize(_width, _height);
			TweenLite.to(super.list, .5, {y:0});
			_delay = setTimeout(dispatchHistoryRendered, 500);
		}
		
		private function collapseList():void
		{
			var n:uint = super.list.numChildren;
			for (var i:int = 0; i < n; i++) super.hideItem(super.list.getChildAt(i), n - i);
		}
		
		private function dispatchHistoryRendered():void
		{
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.HISTORY_RENDERED);
		}
		
	}
	
}
