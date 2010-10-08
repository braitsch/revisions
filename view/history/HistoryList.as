package view.history {
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
		private var _modified			:Boolean;
		private var _branch				:Branch;
		private var _selected			:HistoryItem;
		private var _itemUnsaved		:HistoryItemUnsaved = new HistoryItemUnsaved();	
		
		private var _list				:SimpleList = new SimpleList();
		private var _scrollbar			:UIScrollBar = new UIScrollBar(8, 330, 8, 20);		

		public function HistoryList($branch:Branch, $xpos:uint)
		{
			_branch = $branch;
			_view.tab.x = $xpos * 62;			_view.tab.label_txt.text = $branch.name;
			_view.addEventListener(MouseEvent.CLICK, onRecordSelection);
			
			_list.y = 46;
			addChild(_view);
			addChild(_list);			
			generateScrollbar();
		}

		public function set modified(m:Boolean):void 
		{			_modified = m;
			if (_selected) {
				switchToVersion();
			}	else{
				rebuildList();
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

		private function onRecordSelection(e:MouseEvent):void 
		{
			trace('------------------------------');
			_selected = e.target as HistoryItem;
			AppModel.status.getStatus();		
		}
		
		private function switchToVersion():void
		{
			if (_selected == _itemUnsaved) {
				AppModel.history.checkoutMaster();
			} else{
				AppModel.history.checkoutCommit(_selected.sha1);
			}		
			_selected = null;	
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
