package view.history {

	import model.Commit;
	import view.layout.ListItem;

	public class HistoryListItem extends ListItem {

		private var _view			:HistoryItemMC = new HistoryItemMC();
		private var _commit			:Commit;

		public function HistoryListItem(c:Commit)
		{
			super.draw(650, 20);
			
			_commit = c;
			_view.num_txt.text = _commit.index;
			_view.date_txt.text = _commit.date;
			addChild(_view);
		}
		
		public function get commit():Commit
		{
			return _commit;
		}
		
		public function set author(a:String):void
		{
			_view.author_txt.text = a;
		}
		
	}
	
}