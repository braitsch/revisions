package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Branch;
	import model.vo.Commit;
	import view.ui.ScrollingList;
	import com.greensock.TweenLite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class HistoryList extends ScrollingList {

		public static const ITEM_SPACING	:uint = 42;
		public static const	ITEMS_PER_PAGE	:uint = 25;
		
		private var _delay					:uint;
		private var _index					:uint;
		private var _total					:uint;
		private var _width					:uint;
		private var _height					:uint;
		private var _modified				:Boolean;
		private var _branch					:Branch;
		private var _itemsSaved				:Vector.<HistoryItemSaved> = new Vector.<HistoryItemSaved>();
		private var _itemUnsaved			:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList()
		{
			super.leading = ITEM_SPACING;
			for (var i:int = 0; i < ITEMS_PER_PAGE; i++) _itemsSaved.push(new HistoryItemSaved(new HistoryItemBkgd()));
		}
		
		override public function clear():void
		{
			super.clear();
			clearTimeout(_delay);
		}		
		
		public function showMostRecent(b:Branch):void
		{
			clearTimeout(_delay);
			_branch = b; _total = _branch.history.length;
			_index = _total - ITEMS_PER_PAGE > 0 ? _total - ITEMS_PER_PAGE : 0;
			drawList();
		}
		
		public function startFromIndex(b:Branch, n:uint):void
		{
			clearTimeout(_delay);
			_branch = b; _total = _branch.history.length;
			_index = n;
			drawList();
		}
		
		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			super.draw(_width, _height);
			for (var i:int = 0; i < super.list.numChildren; i++) HistoryItem(super.list.getChildAt(i)).setWidth(_width);
		}
		
		private function drawList():void
		{
			getModified();
		//	var k:Number = getTimer();
			var n1:uint = _index;
			var n2:uint = _index > _total - ITEMS_PER_PAGE ? _total : _index + ITEMS_PER_PAGE;
			var v:Vector.<Commit> = _branch.history.slice(n1, n2).reverse();
			for (var i:int = 0; i < ITEMS_PER_PAGE; i++) {
				if (i < v.length){
					_itemsSaved[i].commit = v[i];
					super.showItem(_itemsSaved[i], _modified ? i + 1 : i);
				}	else{
					super.hideItem(_itemsSaved[i], super.list.numChildren - i);
				}
				_itemsSaved[i].y = ITEM_SPACING * (_modified ? i + 1 : i);
			}
			setSize(_width, _height);
			TweenLite.to(super.list, .5, {y:0});
		//	trace("HistoryList.drawList()", n1, n2, 'ms=', getTimer() - k);
			_delay = setTimeout(dispatchHistoryRendered, 500);
		}

		private function getModified():void
		{
			_modified = _branch.isModified && (_index >= _total - ITEMS_PER_PAGE - 1);
			if (_modified){
				super.showItem(_itemUnsaved, 0, 0);
			}	else{
				super.hideItem(_itemUnsaved, 0, 0);
			}			
		}

		public function dispatchHistoryRendered():void
		{
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.HISTORY_RENDERED);
		}
		
	}
	
}
