package view.history {
	import flash.display.Sprite;

	public class HistoryCrumb extends Sprite {

		private var _view:HistoryCrumbMC = new HistoryCrumbMC();

		public function HistoryCrumb($label:String)
		{
			addChild(_view);
			_view.label_txt.text = $label;
		}
	}
	
}
