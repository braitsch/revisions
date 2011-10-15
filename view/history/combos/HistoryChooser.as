package view.history.combos {

	import view.history.HistoryList;
	import events.UIEvent;
	import model.AppModel;

	public class HistoryChooser extends ComboGroup {

		public function HistoryChooser()
		{
			super(ClockIcon, ClockIcon, 32, false);
			addEventListener(UIEvent.COMBO_OPTION_CLICK, onOptionClick);
		}
		
		public function draw():void
		{
			super.heading = 'History of '+AppModel.bookmark.label;
			var a:Array = [];
			var p:uint = HistoryList.ITEMS_PER_PAGE;
			var t:uint = getNumDigits();
			var n:uint = Math.ceil(AppModel.bookmark.branch.totalCommits / p);
			if (n > 1){
				for (var i:int = 0; i < n; i++) {
					var k:uint = (i * p) + 1;
					if (i < n-1){
						a.push('View Saved Versions '+pad(k, t)+' - '+pad(k + p - 1, t));
					}	else{
						a.push('View Saved Versions '+k+' - '+AppModel.bookmark.branch.totalCommits);
					}
				}
			}
			super.options = a.reverse();
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
		
		private function pad(k:uint, n:uint):String
		{
			var s:String = k.toString();
			while (s.length < n) s = '0'+s; 
			return s;
		}
		
		private function onOptionClick(e:UIEvent):void
		{
			trace("HistoryChooser.onOptionClick(e)", e.data);	
		}			
		
	}
	
}
