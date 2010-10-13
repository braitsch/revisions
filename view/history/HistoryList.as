package view.history {
	import commands.UICommand;

	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Branch;
	import view.layout.ListItem;
	import view.layout.SimpleList;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryList extends Sprite {

	// each one of these represent one branch on a bookmark //
	
		private var _list				:SimpleList = new SimpleList();
		private var _view				:HistoryListMC = new HistoryListMC();
		private var _branch				:Branch;
		private var _modified			:uint;		// record the last modified value //
		private var _itemUnsaved		:HistoryItemUnsaved;

		public function HistoryList($branch:Branch, $xpos:uint)
		{
			_branch = $branch;
			_itemUnsaved = new HistoryItemUnsaved(_branch.name);
			
			_view.tab.x = $xpos * 62;
			_view.tab.buttonMode = true;
			_view.tab.alpha = .6;
			_view.tab.label_txt.text = $branch.name;			_view.tab.label_txt.mouseEnabled = false;
			_view.mouseEnabled = false;
			
			_list.y = 46;
			_list.setSize(650, 308);
			_list.scrollbar.y = -22;
			_list.scrollbar.x = 655;
			addChild(_view);
			addChild(_list);
			
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			_view.tab.addEventListener(MouseEvent.CLICK, onListTabSelection);
			
			_branch.addEventListener(RepositoryEvent.BRANCH_STATUS, onStatus);			_branch.addEventListener(RepositoryEvent.BRANCH_HISTORY, drawList);
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

	// private //	
	
		private function onStatus(e:RepositoryEvent):void 
		{
		// only rebuild if the modified # has changed //
			if (_modified != _branch.modified) {
				_modified = _branch.modified;
				if (_branch.history != null) drawList();
			}
		}			

		private function drawList(e:RepositoryEvent = null):void
		{
			var a:Array = _branch.history;
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			
		// only show unsaved item for the current branch 
		// since you cannot checkout another branch if you have local changes	
			if (_branch==AppModel.repos.bookmark.branch) {
				if (_branch.modified) v.push(_itemUnsaved);
			}
			
			for (var i:int = 0; i < a.length; i++) {
				var n:Array = a[i].split('##');
				var o:Object = {	index : String(a.length-i),
									date : n[1], 
									author : n[2], 
									note : n[3], 
									sha1 : n[0],	
									name : _branch.name	};
				v.push(new HistoryItem(o));
			}
			_list.refresh(v);
			trace("HistoryList.rebuildList > ", '# items = '+a.length);			
		}
		
	// click events //	
		
		private function onListTabSelection(e:MouseEvent):void 
		{
		// this action DOES NOT changes branches //
		// here is where we load the history of a branch 
		// the first time it is selected in the tab view
			if (_branch.history==null) _branch.getHistory();	
			dispatchEvent(new UICommand(UICommand.HISTORY_TAB_SELECTED));
		}		

		private function onRecordSelection(e:MouseEvent):void 
		{
			dispatchEvent(new UICommand(UICommand.HISTORY_ITEM_SELECTED, _list.activeItem));		}
		
	}
	
}
