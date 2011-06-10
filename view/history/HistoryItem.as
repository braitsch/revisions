package view.history {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class HistoryItem extends Sprite {

		private var _view:*;
		private var _mask:Shape = new Shape();

		public function HistoryItem(view:*)
		{
			_view = view;
			_view.num_txt.x = 9;
			_view.time_txt.x = 50;
			_view.details_txt.x = 172;
			_view.details_txt.mask = _mask;
			_view.num_txt.mouseEnabled = false;
			_view.time_txt.mouseEnabled = false;
			_view.details_txt.mouseEnabled = false;
			_view.num_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.time_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.details_txt.autoSize = TextFieldAutoSize.LEFT;
			_mask.graphics.beginFill(0xff0000);		
			_mask.graphics.drawRect(0, 0, 200, 29);
			_mask.graphics.endFill();
			_view.addChild(_mask);
		}

		public function resize(w:uint):void { }
		public function get textMask():Shape { return _mask; }
		
	}
	
}
