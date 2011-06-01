package view{

	import view.history.HistoryView;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class MainView extends Sprite {

		private static var _pattern		:Shape = new Shape();
		private static var _history		:HistoryView = new HistoryView();

		public function MainView()
		{
			addChild(_pattern);
			addChild(_history);
		}

		public function resize(w:uint, h:uint):void
		{
			_history.resize(w, h);
			_pattern.graphics.beginBitmapFill(new LtGreyPattern());	
			_pattern.graphics.drawRect(0, 0, w, h);	
			_pattern.graphics.endFill();	
		}
		
	}
	
}
