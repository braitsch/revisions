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
			_branch.addEventListener(RepositoryEvent.BRANCH_UPDATED, rebuildList);
		}

		public function set active(b:Boolean):void
		{
			_view.tab.alpha = b ? 1 : .6;
		}
		
		public function get branch():Branch
		{
			return _branch;
		}			

		public function onStatusReceived():void 
		{	
			if (_selected) checkoutVersion();		}
		
	// private //	

		private function rebuildList(e:RepositoryEvent):void
		{
			var a:Array = _branch.history;
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			
			if (_branch.modified) v.push(_itemUnsaved);
			for (var i:int = 0; i < a.length; i++) {
				var n:Array = a[i].split('##');
				v.push(new HistoryItem(String(a.length-i), n[1], n[2], n[3], n[0]));
			}
			_list.refresh(v);
			trace("HistoryList.rebuildList > ", '# items = '+a.length, '_modified = ', _branch.modified);			
		}
		
	// click events //	
		
		private function onListTabSelection(e:MouseEvent):void 
		{
			AppModel.bookmark.branch = _branch;
			dispatchEvent(new UICommand(UICommand.BRANCH_SELECTED));
		}		

		private function onRecordSelection(e:MouseEvent):void 
		{
			return;
			trace('------------------------------');
			_selected = true;
		// always force refresh the status before checkout of target branch..	
			AppModel.status.getStatusOfBranch();		
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
