package view.history {
	import flash.display.Sprite;

	public class HistoryItem extends Sprite {

		private var _view			:HistoryItemMC = new HistoryItemMC();

		public function HistoryItem(n:uint, d:Object)
		{
			_view.num_txt.text = String(n+1);			_view.date_txt.text = d.dates[n];			_view.author_txt.text = d.authors[n];			_view.note_txt.text = d.notes[n];
			addChild(_view);
		}
		
	}
	
}
