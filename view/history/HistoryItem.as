package view.history {
	import view.layout.ListItem;

	public class HistoryItem extends ListItem {

		private var _sha1			:String;
		private var _view			:HistoryItemMC = new HistoryItemMC();

		public function HistoryItem(i:String, d:String, a:String, n:String, s:String = 'XX')
		{
			super(650, false);
			_view.num_txt.text = i;
			_view.date_txt.text = d;			_view.author_txt.text = a;			_view.note_txt.text = n;			_sha1 = s;			mouseChildren = false;
			addChild(_view);
		}
		
		public function set author(a:String):void
		{
			_view.author_txt.text = a;
		}

		public function get sha1():String
		{
			return _sha1;
		}
		
	}
	
}
