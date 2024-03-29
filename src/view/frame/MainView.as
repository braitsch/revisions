package view.frame{

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.graphics.PatternBox;
	import view.graphics.SolidBox;
	import view.history.HistoryView;
	import view.summary.SummaryView;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;

	public class MainView extends Sprite {

		private static var _curtain		:Sprite = new Sprite();
		private static var _blkBox		:SolidBox = new SolidBox(0x000000);
		private static var _pattern		:PatternBox = new PatternBox(new LtGreyPattern());
		private static var _summary		:SummaryView = new SummaryView();
		private static var _history		:HistoryView = new HistoryView();
		private static var _bkgdBlur	:BlurFilter = new BlurFilter(2, 2, 3);

		public function MainView()
		{
			addChild(_pattern);
			addChild(_history);
			addChild(_curtain);
			addChild(_summary);
			
			_curtain.addChild(_blkBox);
			_curtain.visible = _summary.visible = false;
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			_summary.addEventListener(UIEvent.SHOW_HISTORY, onShowHistory);
			
			AppModel.engine.addEventListener(AppEvent.NO_BOOKMARKS, onNoBookmarks);
			AppModel.engine.addEventListener(AppEvent.SUMMARY_RECEIVED, onBookmarkSelected);
		}

		public function resize(w:uint, h:uint):void
		{
			_history.resize(w, h);
			_summary.resize(h - 100);
			_summary.x = Math.round(w / 2 - 175);
			_blkBox.draw(w, h); _pattern.draw(w, h);
		}

		private function onShowHistory(e:UIEvent):void { refreshHistory(); }
		private function onCurtainClick(e:MouseEvent):void { refreshHistory(); }
		
		private function refreshHistory():void
		{
			AppModel.dispatch(AppEvent.HISTORY_REQUESTED);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RENDERED, onHistoryRendered);
		}
		
		private function onHistoryRendered(e:AppEvent):void
		{
			hideSummary();
			AppModel.engine.removeEventListener(AppEvent.HISTORY_RENDERED, onHistoryRendered);
		}
		
		private function onNoBookmarks(e:AppEvent):void
		{
			hideSummary();
		}
		
		private function onBookmarkSelected(e:AppEvent):void
		{
			if (_summary.visible == false) showSummary();
		}		
		
		private function showSummary():void
		{
			_history.filters = [_bkgdBlur];
			_curtain.alpha = _summary.alpha = 0;
			_curtain.visible = _summary.visible = true;
			TweenLite.to(_curtain, .5, {alpha:.5});
			TweenLite.to(_summary, .5, {alpha: 1});
		}		
		
		private function hideSummary():void
		{
			_history.filters = [];
			TweenLite.to(_summary, .3, {alpha:0, onComplete:function():void{_summary.visible=false;}});
			TweenLite.to(_curtain, .3, {alpha:0, onComplete:function():void{_curtain.visible=false;}});
		}

	}
	
}
