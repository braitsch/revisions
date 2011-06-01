package view.history {

	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class HistoryItem extends Sprite {

		private var _view:*;

		public function HistoryItem(view:*)
		{
			_view = view;
			_view.num_txt.x = 9;
			_view.time_txt.x = 50;
			_view.details_txt.x = 172;
			_view.num_txt.mouseEnabled = false;
			_view.time_txt.mouseEnabled = false;
			_view.details_txt.mouseEnabled = false;
			_view.num_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.time_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.details_txt.autoSize = TextFieldAutoSize.LEFT;			
		}
		
		public function resize(w:uint):void {}
		
	}
	
}
