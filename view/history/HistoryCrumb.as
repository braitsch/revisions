package view.history {
	import flash.display.Sprite;

	public class HistoryCrumb extends Sprite {

		private var _view:HistoryCrumbMC = new HistoryCrumbMC();

		public function HistoryCrumb($name:String)
		{
			addChild(_view);
			this.name = $name;
			mouseChildren = false;	
			_view.label_txt.text = $name;
		}
	}
	
}
