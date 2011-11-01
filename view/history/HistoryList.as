package view.history {

	import events.AppEvent;
	import model.AppModel;
	import model.vo.Commit;
	import view.ui.ScrollingList;
	import com.greensock.TweenLite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class HistoryList extends ScrollingList {

		public static const	ITEMS_PER_PAGE	:uint = 25;
		
		private var _delay					:uint;
		private var _index					:uint;
		private var _total					:uint;
		private var _width					:uint;
		private var _height					:uint;
		private var _modified				:Boolean;
		private var _itemsSaved				:Vector.<HistoryItemSaved> = new Vector.<HistoryItemSaved>();
		private var _itemUnsaved			:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList()
		{
			super.leading = 42;
			super.bkgdColor = 0x999999;
			for (var i:int = 0; i < ITEMS_PER_PAGE; i++) _itemsSaved.push(new HistoryItemSaved());
		}
		
		public function showMostRecent():void
		{
			clearTimeout(_delay);
			_total = AppModel.branch.history.length;
			_index = _total - ITEMS_PER_PAGE > 0 ? _total - ITEMS_PER_PAGE : 0;
			_delay = setTimeout(drawList, 500);
		}
		
		public function showFromIndex(n:uint):void
		{
			clearTimeout(_delay);
			_total = AppModel.branch.history.length;
			_index = n;
			drawList();
		}
		
		public function killHistory():void
		{
			clearTimeout(_delay);
			var n:uint = super.list.numChildren;
			for (var i:int = 0; i < n; i++) super.hideItem(super.list.getChildAt(i), n - i);			
		}

		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			super.draw(_width, _height);
			for (var i:int = 0; i < super.list.numChildren; i++) HistoryItem(super.list.getChildAt(i)).setWidth(_width);
		}
		
		private function drawList():void
		{
			if (AppModel.branch.history == null) return;
			getModified();
		//	var k:Number = getTimer();
			var n1:uint = _index;
			var n2:uint = _index > _total - ITEMS_PER_PAGE ? _total : _index + ITEMS_PER_PAGE;
			var v:Vector.<Commit> = AppModel.branch.history.slice(n1, n2).reverse();
			for (var i:int = 0; i < ITEMS_PER_PAGE; i++) {
				if (i < v.length){
					_itemsSaved[i].commit = v[i];
					super.showItem(_itemsSaved[i], _modified ? i + 1 : i);
				}	else{
					super.hideItem(_itemsSaved[i], super.list.numChildren - i);
				}
				_itemsSaved[i].y = 42 * (_modified ? i + 1 : i);
			}
			setSize(_width, _height);
			TweenLite.to(super.list, .5, {y:0});
		//	trace("HistoryList.drawList()", n1, n2, 'ms=', getTimer() - k);
			_delay = setTimeout(dispatchHistoryRendered, 500);
		}

		private function getModified():void
		{
			_modified = AppModel.branch.isModified && (_index >= _total - ITEMS_PER_PAGE - 1);
			if (_modified){
				super.showItem(_itemUnsaved, 0, 0);
			}	else{
				super.hideItem(_itemUnsaved, 0, 0);
			}			
		}

		private function dispatchHistoryRendered():void
		{
			AppModel.hideLoader();
			AppModel.dispatch(AppEvent.HISTORY_RENDERED);
		}
		
	}
	
}
