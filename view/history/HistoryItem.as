package view.history {
	import view.layout.ListItem;

	public class HistoryItem extends ListItem {

		private var _view			:HistoryItemMC = new HistoryItemMC();
		private var _sha1			:String;			

		public function HistoryItem(n:uint, s:String)
		{
			super(650, false);
			var a:Array = s.split('##');
			_sha1 = a[0];
			_view.num_txt.text = n.toString();			_view.date_txt.text = a[1]; 			_view.author_txt.text = a[2];			_view.note_txt.text = a[3];
			mouseChildren = false;
			addChild(_view);
		}
		
		public function get sha1():String
		{
			return _sha1;
		}
	}
}
