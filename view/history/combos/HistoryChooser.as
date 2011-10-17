package view.history.combos {

	import events.UIEvent;
	import model.AppModel;
	import view.history.HistoryList;

	public class HistoryChooser extends ComboGroup {

		private static var _options		:Vector.<String>;
		private static var _pageNum		:uint;
		private static var _spacers		:uint;
		private static var _numPerPage	:uint;

		public function HistoryChooser()
		{
			super(ClockIcon, ClockIcon, 32, false);
			addEventListener(UIEvent.COMBO_OPTION_CLICK, onOptionClick);
		}
		
		public function draw():void
		{
			_pageNum = 0;
			_options = new Vector.<String>();
			_spacers = getNumDigits();
			_numPerPage = HistoryList.ITEMS_PER_PAGE;
			var n:uint = Math.floor(AppModel.bookmark.branch.totalCommits / _numPerPage);
			if (n > 1){
				for (var i:int = 0; i < n; i++) {
					var k:uint = (i * _numPerPage);
					_options.push('View Saved Versions '+pad(k + 1)+' - '+pad(k + _numPerPage));
				}
				_options.push('View Most Recent Versions');
			}
			super.heading = 'History of '+AppModel.bookmark.label;
			sort(_pageNum);
		}
		
		private function sort(n:uint):void
		{
			var v:Vector.<String> = _options.concat();
				v.reverse();
				v.splice(n, 1);
			super.options = v;
		}
		
		private function onOptionClick(e:UIEvent):void
		{
			var i:uint = e.data as uint;
			_pageNum = i <= _pageNum ? i - 1 : i;
			var tc:uint = AppModel.bookmark.branch.totalCommits;
			var n1:uint = (Math.floor(tc / _numPerPage) - _pageNum) * _numPerPage;
			if (tc - n1 < _numPerPage){
				n1 = tc - _numPerPage;
				super.heading = 'History of '+AppModel.bookmark.label;		
			}	else{
				super.heading = 'Viewing Versions '+pad(n1 + 1)+' - '+pad(n1 + _numPerPage);
			}
			sort(_pageNum);
			dispatchEvent(new UIEvent(UIEvent.PAGE_HISTORY, n1));
		}			
		
		private function getNumDigits():uint
		{
			var n:uint = AppModel.bookmark.branch.totalCommits;
			if (n < 10){
				return 1;
			}	else if (n < 100){
				return 2;
			}	else if (n < 1000){
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
