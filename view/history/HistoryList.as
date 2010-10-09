package view.history {
	import view.bookmarks.Bookmark;
	import commands.UICommand;
	import model.AppModel;

	import view.bookmarks.Branch;
	import view.layout.ListItem;
	import view.layout.SimpleList;
	import view.ui.UIScrollBar;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryList extends Sprite {

	// each one of these represent one branch on a bookmark //
	
		private var _view				:HistoryListMC = new HistoryListMC();
		private var _branch				:Branch;
		private var _modified			:Boolean;
		private var _selected			:Boolean;
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();	
		
		private var _list				:SimpleList = new SimpleList();
		private var _scrollbar			:UIScrollBar = new UIScrollBar(8, 330, 8, 20);		

		public function HistoryList($branch:Branch, $xpos:uint)
		{
			_branch = $branch;
			_view.tab.x = $xpos * 62;
			_view.tab.buttonMode = true;
			_view.tab.label_txt.mouseEnabled = false;
			_view.mouseEnabled = false;
			
			_list.y = 46;
			addChild(_view);
			addChild(_list);
			
			_list.addEventListener(MouseEvent.CLICK, onRecordSelection);
			generateScrollbar();
		}

		public function set modified(m:Boolean):void 
		{
			if (_selected) {		 
				checkoutVersion();
			}	else{
			// never draw the detached branch - confuses the user //	
				var x:Boolean = m!=_modified;
				if (AppModel.bookmark.branch.name==Bookmark.DETACH) return;
				if (!_list.activeItem || x==true) rebuildList();
			}
		}
		
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

		private function rebuildList():void
		{
			var a:Array = AppModel.bookmark.branch.history;
			var v:Vector.<ListItem> = new Vector.<ListItem>();
			
			if (_modified) v.push(_itemUnsaved);
			for (var i:int = 0; i < a.length; i++) {
				var n:Array = a[i].split('##');
				v.push(new HistoryItem(String(a.length-i), n[1], n[2], n[3], n[0]));
			}
			_list.refresh(v);
			
		// check if we need the scrollbar //	
			_scrollbar.visible = _list.height > 314;
			trace("HistoryList.rebuildList > ", '# items = '+a.length, '_modified = ', _modified);			
		}
		
		private function onListTabSelection(e:MouseEvent):void 
		{
			dispatchEvent(new UICommand(UICommand.BRANCH_SELECTED));
		}		

		private function onRecordSelection(e:MouseEvent):void 
		{
			trace('------------------------------');
			_selected = true;
		// always force refresh the status before checkout of target branch..	
			AppModel.status.getStatus();		
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
		
		private function generateScrollbar():void 
		{
			_scrollbar.y = 24;
			_scrollbar.x = 655;
			_scrollbar.target = _list;
			_scrollbar.drawMask(650, 308);
			_scrollbar.visible = false;
			addChild(_scrollbar);	
		}			

	}
	
}