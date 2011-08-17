package view{

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.history.HistoryView;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
			addChild(_curtain);
			addChild(_summary);
			_curtain.visible = _summary.visible = false;
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			_summary.addEventListener(UIEvent.SHOW_HISTORY, onShowHistory);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, showSummary);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, onNoBookmarks);
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

		private function showSummary(e:BookmarkEvent):void
		{
			if (_curtain.visible) return;
			TweenLite.from(_curtain, .5, {alpha:0});
			TweenLite.from(_summary, .5, {alpha:0});
			_curtain.visible = _summary.visible = true;
			_history.filters = [new BlurFilter(2, 2, 3)];
		}
		
		private function onShowHistory(e:UIEvent):void { refreshHistory(); }
		private function onCurtainClick(e:MouseEvent):void { refreshHistory(); }
		
		private function refreshHistory():void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HISTORY_REQUESTED));
			AppModel.engine.addEventListener(AppEvent.HISTORY_RENDERED, onHistoryRendered);
		}
		
		private function onHistoryRendered(e:AppEvent):void
		{
			hideSummary();
			AppModel.engine.removeEventListener(AppEvent.HISTORY_RENDERED, onHistoryRendered);
		}
		
		private function onNoBookmarks(e:BookmarkEvent):void
		{
			hideSummary();
		}
		
		private function hideSummary():void
		{
			_history.filters = [];
			TweenLite.to(_curtain, .3, {alpha:0, onComplete:function():void{_curtain.visible=false; _curtain.alpha=1;}});
			TweenLite.to(_summary, .3, {alpha:0, onComplete:function():void{_summary.visible=false; _summary.alpha=1;}});
		}

	}
	
}
