package view{

	import events.BookmarkEvent;
	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.history.HistoryView;
	import view.ui.Preloader;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.setTimeout;

	public class MainView extends Sprite {

		private static var _pattern		:Shape = new Shape();
		private static var _curtain		:Sprite = new Sprite();
		private static var _summary		:SummaryView = new SummaryView();
		private static var _history		:HistoryView = new HistoryView();
		private static var _preloader	:Preloader = new Preloader();

		public function MainView()
		{
			addChild(_pattern);
			addChild(_history);
			addChild(_curtain);
			addChild(_summary);
			addChild(_preloader);
			_curtain.visible = _summary.visible = false;
			_curtain.addEventListener(MouseEvent.CLICK, onCurtainClick);
			_summary.addEventListener(UIEvent.SHOW_HISTORY, onShowHistory);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, showSummary);
			AppModel.engine.addEventListener(BookmarkEvent.LOADED, hideLoader);
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_SETTINGS, showLoader);			
		}
		
		public function resize(w:uint, h:uint):void
		{
			_summary.resize(h);
			_history.resize(w, h);
			_summary.x = Math.round(w/2 - 175);
			_preloader.x = w/2;
			_preloader.y = h/2 - 50;
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
		
		private function onShowHistory(e:UIEvent):void { checkHistoryExists(); }
		private function onCurtainClick(e:MouseEvent):void { checkHistoryExists(); }
		
	// request history if it doesn't exist so the user isn't left with an empty screen //	
		private function checkHistoryExists():void
		{
			if (AppModel.bookmark.branch.history) {
				hideSummary();			
			}	else{
				_preloader.show();
				addEventListener(UIEvent.HISTORY_DRAWN, onHistory);	
				setTimeout(function():void{AppModel.proxies.history.getHistory();}, 500);
			}
		}
		
		private function onHistory(e:UIEvent):void
		{
			setTimeout(hideSummary, 500);
			removeEventListener(UIEvent.HISTORY_DRAWN, onHistory);	
		}
		
		private function hideSummary():void
		{
			_preloader.hide();
			_history.filters = [];
			TweenLite.to(_curtain, .3, {alpha:0, onComplete:function():void{_curtain.visible=false; _curtain.alpha=1;}});
			TweenLite.to(_summary, .3, {alpha:0, onComplete:function():void{_summary.visible=false; _summary.alpha=1;}});
		}

		private function showLoader(e:InstallEvent):void
		{
			_preloader.show();
		}
		
		private function hideLoader(e:BookmarkEvent):void 
		{
			_preloader.hide();
		}			
		
	}
	
}
