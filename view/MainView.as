package view{

	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.history.HistoryView;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	public class MainView extends Sprite {

		private static var _pattern		:Shape = new Shape();
		private static var _curtain		:Sprite = new Sprite();
		private static var _summary		:SummaryView = new SummaryView();
		private static var _history		:HistoryView = new HistoryView();

		public function MainView()
		{
			addChild(_pattern);
			addChild(_history);
			addEventListener(UIEvent.SHOW_HISTORY, onShowHistory);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
		}

		private function onShowHistory(e:UIEvent):void
		{
			removeChild(_curtain);	
			removeChild(_summary);
			_history.filters = [];
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			addChild(_curtain);
			addChild(_summary);
			_history.filters = [new BlurFilter(2, 2, 3)];
		}

		public function resize(w:uint, h:uint):void
		{
			_summary.resize(h);
			_history.resize(w, h);
			_summary.x = Math.round(w/2 - 175);
			_pattern.graphics.beginBitmapFill(new LtGreyPattern());	
			_pattern.graphics.drawRect(0, 0, w, h);	
			_pattern.graphics.endFill();
			_curtain.graphics.clear();	
			_curtain.graphics.beginFill(0x000000, .5);
			_curtain.graphics.drawRect(0, 0, w, h);
			_curtain.graphics.endFill();				
		}
		
	}
	
}
