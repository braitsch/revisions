package view.history {
	import events.RepositoryEvent;
	import commands.UICommand;

	import model.AppModel;

	import view.bookmarks.Bookmark;
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
		private var _selected			:Boolean;
		private var _modified			:uint;		// record the last modified value //
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();	

		public function HistoryList($branch:Branch, $xpos:uint)
		{
			_branch = $branch;
			
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

		public function onStatusReceived():void 
		{				if (_selected) checkoutVersion();
		}
		
	// private //	
	
		private function onStatus(e:RepositoryEvent):void 
		{
			if (_branch.history == null) return;
		// only rebuild if the modified # has changed //
			if (_modified != _branch.modified) {
				_modified = _branch.modified;
				drawList();
			}
		}			

		private function drawList(e:RepositoryEvent = null):void
		{
			var a:Array = _branch.history;
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			
		// only show unsaved item for the current branch 
		// since you cannot checkout another branch if you have local changes	
			if (_branch==AppModel.bookmark.branch) {
				if (_branch.modified) v.push(_itemUnsaved);
			}
			
			for (var i:int = 0; i < a.length; i++) {
				var n:Array = a[i].split('##');
				v.push(new HistoryItem(String(a.length-i), n[1], n[2], n[3], n[0]));
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
			return;
			trace('------------------------------');
			_selected = true;
		// always force refresh the status before checkout of target branch..				AppModel.status.getStatusOfBranch(_branch);		
		}
		
	// checkouts //	
		
		private function checkoutVersion():void
		{
		// check the status of the current branch before we shift off of it //	
			var b:Branch = AppModel.bookmark.branch;
			if (b.name==Bookmark.DETACH && b.modified==true){
				dispatchEvent(new UICommand(UICommand.DETACHED_BRANCH_EDITED));
			} else{
				switchToVersion();
			}
		}		
		
		private function switchToVersion():void
		{
			var k:HistoryItem = _list.activeItem as HistoryItem;
			if (_list.getChildIndex(k)==0) {
				AppModel.history.checkoutMaster();
			} else{
				AppModel.history.checkoutCommit(k.sha1);
			}		
			_selected = false;	
		}
		
	}
	
}
