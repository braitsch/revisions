package view.history {

	import events.RepositoryEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.Branch;
	import model.Commit;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryList extends Sprite {

	// each one of these represent one branch on a bookmark //
	
		private var _list				:SimpleList = new SimpleList();
		private var _view				:HistoryListMC = new HistoryListMC();
		private var _cached				:uint;		// cached modified value //
		private var _branch				:Branch;
		private var _itemUnsaved		:HistoryItemUnsaved;

		public function HistoryList($branch:Branch, $xpos:uint)
		{
			_branch = $branch;
			_itemUnsaved = new HistoryItemUnsaved(_branch);
			
			_view.tab.x = $xpos * 62;
			_view.tab.buttonMode = true;
			_view.tab.alpha = .6;
			_view.tab.label_txt.text = _branch.name == 'master' ? 'home' : _branch.name;
			_view.tab.label_txt.mouseEnabled = false;
			_view.mouseEnabled = false;
			
			_list.y = 46;
			_list.setSize(650, 308);
			_list.scrollbar.y = -22;
			_list.scrollbar.x = 655;
			addChild(_view);
			addChild(_list);
			
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			_view.tab.addEventListener(MouseEvent.CLICK, onListTabSelection);
			_branch.addEventListener(RepositoryEvent.BRANCH_HISTORY, drawList);
		}
		
	// public //	

		public function set active(on:Boolean):void
		{
			_view.tab.alpha = on ? 1 : .6;
		}
		
		public function get branch():Branch
		{
			return _branch;
		}
		
		public function onStatusRefresh():void
		{
			trace("HistoryList.onStatusRefresh() _cached =", _cached, '_modified =', _branch.modified);
		// only rebuild if the modified # has changed //
			if (_branch.modified != _cached) drawList();
		}

	// private //
		
		private function drawList(e:RepositoryEvent = null):void
		{
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			
			if (_branch.modified) v.push(_itemUnsaved);
			_cached = _branch.modified;
			
			var a:Array = _branch.history;
			for (var i:int = 0; i < a.length; i++) {
				var o:Object = {	index : String(a.length-i),
									date 	: a[i][1],
									author 	: a[i][2],
									note 	: a[i][3],
									sha1 	: a[i][0],
									branch 	: _branch};
				v.push(new HistoryListItem(new Commit(o)));
			}
			_list.clear();
			_list.build(v);
			trace("HistoryList.rebuildList > ", '# items = '+a.length);			
		}
		
	// click events //	
		
		private function onListTabSelection(e:MouseEvent):void 
		{
			if (_branch.history == null) AppModel.proxies.history.getHistoryOfBranch(_branch);
			dispatchEvent(new UIEvent(UIEvent.HISTORY_TAB_SELECTED));
		}		

		private function onRecordSelection(e:MouseEvent):void 
		{
			var k:HistoryListItem = _list.activeItem as HistoryListItem;
			if (k.index == 0){
				AppModel.proxies.checkout.checkoutBranch(AppModel.bookmark, _branch);					}	else{
				AppModel.proxies.checkout.checkoutBranch(AppModel.bookmark, k.commit);		
			}
		}
		
	}
	
}
