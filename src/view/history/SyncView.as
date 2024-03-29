package view.history {

	import com.greensock.TweenLite;
	import events.AppEvent;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import model.AppModel;
	import model.vo.Branch;
	import model.vo.Commit;
	import view.graphics.PatternBox;
	import view.graphics.SolidBox;
	import view.windows.modals.merge.SyncWindow;

	public class SyncView extends Sprite {

		private static var _bkgd			:PatternBox = new PatternBox(new LtGreyPattern());
		private static var _divider			:SolidBox = new SolidBox(0xffffff);
		private static var _width			:uint;
		private static var _height			:uint;
		private static var _branchB			:Branch;
		private static var _branchAList		:HistorySnapshot;
		private static var _branchBList		:HistorySnapshot;
		private static var _aUnique			:Vector.<Commit>;
		private static var _bUnique			:Vector.<Commit>;
		private static var _abShared		:Vector.<Commit>;

		public function SyncView()
		{
			addChild(_bkgd);
			addChild(_divider);
			AppModel.engine.addEventListener(AppEvent.BRANCH_HISTORY, onBranchData);
			AppModel.engine.addEventListener(AppEvent.HIDE_SYNC_VIEW, onHideSyncView);
		}

		public function setSize(w:uint, h:uint):void
		{
			_width = w; _height = h;
			if (_branchAList && _branchBList) drawLayout();
		}
		
		private function onBranchData(e:AppEvent):void
		{
			_aUnique = e.data.a; _bUnique = e.data.b; _branchB = e.data.branch;
			var x:uint = AppModel.branch.history.length - _aUnique.length;
			_abShared = AppModel.branch.history.slice(x - HistoryList.ITEMS_PER_PAGE, x);
			for (var i:int = 0; i < _aUnique.length; i++) _aUnique[i].index = x + i + 1;
			for (var k:int = 0; k < _bUnique.length; k++) _bUnique[k].index = x + k + 1;
			_aUnique.reverse(); _bUnique.reverse(); _abShared.reverse();
			_branchAList = new HistorySnapshot(_aUnique, _abShared);
			_branchBList = new HistorySnapshot(_bUnique, _abShared);
			setTimeout(onListsRendered, 1000);
		}
		
		private function onListsRendered():void
		{
			drawLayout();
			this.visible = true;
			TweenLite.to(this, .5, {alpha:1});
			TweenLite.from(_branchAList, .5, {alpha:0});
			TweenLite.from(_branchBList, .5, {alpha:0});
			addChild(_branchAList); addChild(_branchBList);
			while ( numChildren > 4 ) removeChildAt(2);
			var ac:Commit = _aUnique.length != 0 ? _aUnique[0] : _abShared[0];
			var bc:Commit = _bUnique.length != 0 ? _bUnique[0] : _abShared[0];
			AppModel.alert(new SyncWindow(AppModel.branch, _branchB, _aUnique.length, _bUnique.length, ac, bc));
			AppModel.hideLoader();
		}
		
		private function drawLayout():void
		{
			_divider.x = _width / 2;
			_divider.draw(2, _height);
			_bkgd.draw(_width, _height);
			_branchAList.width = _width / 2;
			_branchBList.width = _width / 2;
			_branchBList.x = _width / 2 + _divider.width;
		}
		
		private function onHideSyncView(e:AppEvent):void
		{
			TweenLite.to(this, .5, {alpha:0, delay:.3, visible:false});	
		}				

	}
	
}
