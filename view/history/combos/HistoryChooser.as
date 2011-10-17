package view.history.combos {

	import events.UIEvent;
	import model.AppModel;
	import view.history.HistoryList;

	public class HistoryChooser extends ComboGroup {

		private static var _options			:Vector.<String>;
		private static var _pageNum			:uint;
		private static var _spacers			:uint;
		private static var _numPerPage		:uint;
		private static var _totalCommits	:uint;

		public function HistoryChooser()
		{
			super(ClockIcon, ClockIcon, 32, false);
			_numPerPage = HistoryList.ITEMS_PER_PAGE;
			addEventListener(UIEvent.COMBO_OPTION_CLICK, onOptionClick);
		}
		
		public function draw():void
		{
			super.heading = 'History of '+AppModel.bookmark.label;
			_options = new Vector.<String>();
			_totalCommits = AppModel.bookmark.branch.totalCommits;
			var n:uint = Math.floor(_totalCommits / _numPerPage);
			if (n > 1) {
				buildAndSort(n);
			}	else{
				super.options = _options;
			}
		}
		
		private function buildAndSort(n:uint):void
		{
			_pageNum = 0; _spacers = getNumZeros();
			_options.push('View Most Recent Versions');
			for (var i:int = n - 1; i >= 0; i--) {
				var k:uint = (i * _numPerPage);
				_options.push('View Saved Versions '+pad(k + 1)+' - '+pad(k + _numPerPage));
			}
			sort(_pageNum);
		}
		
		private function sort(n:uint):void
		{
			var v:Vector.<String> = _options.concat();
				v.splice(n, 1);
			super.options = v;
		}
		
		private function onOptionClick(e:UIEvent):void
		{
			var i:uint = e.data as uint;
			_pageNum = i <= _pageNum ? i - 1 : i;
			var n:uint = (Math.floor(_totalCommits / _numPerPage) - _pageNum) * _numPerPage;
			if (_totalCommits - n < _numPerPage){
				n = _totalCommits - _numPerPage;
				super.heading = 'History of '+AppModel.bookmark.label;		
			}	else{
				super.heading = 'Viewing Versions '+pad(n + 1)+' - '+pad(n + _numPerPage);
			}
			sort(_pageNum);
			dispatchEvent(new UIEvent(UIEvent.PAGE_HISTORY, n));
		}			
		
		private function getNumZeros():uint
		{
			if (_totalCommits < 10){
				return 1;
			}	else if (_totalCommits < 100){
				return 2;
			}	else if (_totalCommits < 1000){
				return 3;
			}	else{
				return 4;
			}
		}
		
		private function pad(k:uint):String
		{
			var s:String = k.toString();
			while (s.length < _spacers) s = '0'+s; 
			return s;
		}
		
	}
	
}
