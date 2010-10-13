package view.history {
	import view.layout.ListItem;

	public class HistoryItem extends ListItem {

		private var _data			:Object;
		private var _view			:HistoryItemMC = new HistoryItemMC();

		public function HistoryItem(o:Object)
		{
			super(650, false);
			_data = o;
			_view.num_txt.text = o.index;
			_view.date_txt.text = o.date;			_view.author_txt.text = o.author;			_view.note_txt.text = o.note;			mouseChildren = false;
			addChild(_view);
		}
		
		public function set author(a:String):void
		{
			_view.author_txt.text = a;
		}
		
		public function get sha1():String
		{
			return _data.sha1;
		}
		
		override public function get name():String
		{
			return _data.name;
		}
		
	}
	
}
