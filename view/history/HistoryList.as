package view.history {

	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import model.vo.Commit;
	import view.ui.ScrollingList;
	import flash.utils.setTimeout;

	public class HistoryList extends ScrollingList {

		private var _width				:uint;
		private var _height				:uint;
		private var _branch				:Branch;
		private var _length				:uint;
		private var _modified			:Boolean;
		private var _itemsSaved			:Vector.<HistoryItemSaved> = new Vector.<HistoryItemSaved>();
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();

		public function HistoryList()
		{
			super.leading = 41;
			super.bottomPadding = -1;
			setTimeout(generateItems, 1000);
		}

		public function set bookmark(b:Bookmark):void
		{
			if (b == null){
				super.clear();
			}	else {
				checkIfChanged();
			}
		}
		
		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			super.draw(_width, _height);
			for (var i:int = 0; i < super.list.numChildren; i++) HistoryItem(super.list.getChildAt(i)).setSize(_width, 41);
		}
		
		private function generateItems():void
		{
			for (var i:int = 0; i < 25; i++) _itemsSaved.push(new HistoryItemSaved());
		}
		
		private function checkIfChanged():void
		{
			var b:Branch =  AppModel.branch;
			var h:uint = AppModel.branch.history.length;
			var m:Boolean = AppModel.branch.isModified;
			if (_branch != b || _length != h || _modified != m){
				_branch = b;
				_length = h;
				_modified = m;
				drawList();
			}
		}

		private function drawList():void
		{
			super.clear();
			if (_modified) super.addItem(_itemUnsaved);
			var v:Vector.<Commit> = AppModel.branch.history;
			for (var i:int = 0; i < v.length; i++) {
				var k:HistoryItemSaved = _itemsSaved[i];
					k.commit = v[i];
				super.addItem(k, .05*i);
			}
			setSize(_width, _height);
		}
		
	}
	
}
