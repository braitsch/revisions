package view.ui {

	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	public class Tooltip extends Sprite {

		private var _view	:TooltipMC = new TooltipMC();
	
		public function Tooltip(label:String)
		{
			addChild(_view);
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			_view.label_txt.text = label;
			_view.label_txt.filters = [new GlowFilter(0x000000, .5, 20, 20, 2, 2)];			
		}
	}
}
