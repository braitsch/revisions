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

		public static const	ITEMS_PER_PAGE	:uint = 25;
		private var _delay					:uint;
		private var _width					:uint;
		private var _height					:uint;
		private var _branch					:Branch;
		private var _itemsSaved				:Vector.<HistoryItemSaved> = new Vector.<HistoryItemSaved>();
		private var _itemUnsaved			:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList()
		{
			super.leading = 41;
			super.bottomPadding = -1;
			for (var i:int = 0; i < ITEMS_PER_PAGE; i++) _itemsSaved.push(new HistoryItemSaved());
		}

		public function set branch(b:Branch):void
		{
			clearTimeout(_delay);
			if (b == null){
				collapseList();
			}	else {
				_branch = b; _delay = setTimeout(drawList, 500);
			}
		}
		
		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			super.draw(_width, _height);
			for (var i:int = 0; i < super.list.numChildren; i++) HistoryItem(super.list.getChildAt(i)).setSize(_width, 41);
		}
		
		private function drawList():void
		{
			var m:Boolean = _branch.isModified;
			if (m){
				super.showItem(_itemUnsaved, 0, 0);
			}	else{
				super.hideItem(_itemUnsaved, 0, 0);
			}
			var v:Vector.<Commit> = _branch.history;
			for (var i:int = 0; i < ITEMS_PER_PAGE; i++) {
				if (i < v.length){
					_itemsSaved[i].commit = v[i];
					super.showItem(_itemsSaved[i], m ? i + 1 : i);
				}	else{
					super.hideItem(_itemsSaved[i], super.list.numChildren - i);
				}
				_itemsSaved[i].y = 41 * (m ? i + 1 : i);
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
